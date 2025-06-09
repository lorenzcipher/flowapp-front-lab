import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  List<String> periods = [];
  List<String> categories = [];
  Map<String, Map<String, double>> transactionData = {};
  List<Map<String, dynamic>> forecastData = [];
  List<String> forecastDates = [];
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  bool isForecastLoading = false;
  String selectedPeriod = "weekly";
  bool showPredictedBalance = true;
  double totalCashflow = -222.88;
  double currentBalance = 987.77;
  int selectedDateIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    fetchTransactionData();
    generateMockTransactions();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void generateMockTransactions() {
    transactions = [
      {
        'category': 'Phone',
        'merchant': 'Orange Mobile',
        'date': 'Monday 12AM',
        'amount': -19.90,
        'icon': Icons.phone_android_rounded,
        'color': Color(0xFF4AC7D8),
      },
      {
        'category': 'Food',
        'merchant': 'Carrefour City',
        'date': 'Monday 12AM',
        'amount': -45.89,
        'icon': Icons.local_grocery_store_rounded,
        'color': Color(0xFFFF6B6B),
      },
      {
        'category': 'Food',
        'merchant': 'Biocoop',
        'date': 'Monday 12AM',
        'amount': -55.88,
        'icon': Icons.eco_rounded,
        'color': Color(0xFF4ECDC4),
      },
      {
        'category': 'Restaurant',
        'merchant': 'KFC Chatelet',
        'date': 'Tuesday 8PM',
        'amount': -55.88,
        'icon': Icons.restaurant_rounded,
        'color': Color(0xFFFFB347),
      },
      {
        'category': 'Restaurant',
        'merchant': 'La Voglia',
        'date': 'Wednesday 9PM',
        'amount': -55.88,
        'icon': Icons.local_dining_rounded,
        'color': Color(0xFFFF8A65),
      },
      {
        'category': 'Shopping',
        'merchant': 'Zara Shop',
        'date': 'Wednesday 9PM',
        'amount': -55.88,
        'icon': Icons.shopping_bag_rounded,
        'color': Color(0xFF9B59B6),
      },
      {
        'category': 'Other',
        'merchant': 'Bank Transfer',
        'date': 'Wednesday 9PM',
        'amount': 70.00,
        'icon': Icons.account_balance_rounded,
        'color': Color(0xFF2ECC71),
      },
    ];
  }

  Future<void> fetchTransactionData() async {
    setState(() => isLoading = true);
    final url = 'https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/transactions/totals?period=$selectedPeriod';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('periods')) {
        Map<String, dynamic> periodsData = data['periods'];
        periods = periodsData.keys.toList();

        Set<String> uniqueCategories = {};
        periodsData.forEach((period, details) {
          Map<String, dynamic> categoriesData = details['categories'];
          categoriesData.keys.forEach(uniqueCategories.add);
        });
        categories = uniqueCategories.toList();

        transactionData.clear();
        periodsData.forEach((period, details) {
          Map<String, double> categoryValues = {};
          Map<String, dynamic> categoriesData = details['categories'];
          categoriesData.forEach((category, value) {
            categoryValues[category] = (value as num).toDouble();
          });
          transactionData[period] = categoryValues;
        });

        await fetchForecast();
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchForecast() async {
    setState(() => isForecastLoading = true);
    List<double> totalSpending = periods.map((period) {
      return transactionData[period]?.values.fold(0.0, (sum, value) => (sum ?? 0.0) + (value ?? 0.0)) ?? 0.0;
    }).toList();

    final url = "https://balance-forecast-api-fjfpdqg4bvf2a3hr.francecentral-01.azurewebsites.net/forecast";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "account_id": "37",
        "period": selectedPeriod,
        "num_periods": periods.length,
        "total_spending": totalSpending,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        forecastData = List<Map<String, dynamic>>.from(data["forecast"]);
        forecastDates = forecastData.map((forecast) => forecast["date"] as String).toList();
        isForecastLoading = false;
      });
    } else {
      setState(() => isForecastLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F23),
      body: SafeArea(
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Color(0xFF4AC7D8),
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Loading your finances...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        )
            : FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Enhanced Header with glassmorphism effect
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Enhanced Modify button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showPredictedBalance = !showPredictedBalance;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: showPredictedBalance
                                  ? [Color(0xFF667eea), Color(0xFF764ba2)]
                                  : [Color(0xFF333333), Color(0xFF555555)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (showPredictedBalance ? Color(0xFF667eea) : Colors.black).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                showPredictedBalance ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Modify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Enhanced Period selector
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF1A1A2E),
                                    Color(0xFF16213E),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Select Period',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildPeriodOption('Weekly', 'weekly'),
                                  SizedBox(height: 12),
                                  _buildPeriodOption('Monthly', 'monthly'),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4AC7D8), Color(0xFF36B5C0)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF4AC7D8).withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedPeriod == "weekly" ? 'Weekly View' : 'Monthly View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced Date selector with smooth animations
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      List<String> dates = ['05/05', '12/05', '19/05', '26/05', '02/06', '09/06'];
                      bool isSelected = index == selectedDateIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDateIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(right: 12),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                              colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                            )
                                : LinearGradient(
                              colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                              width: 1,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: Color(0xFF9B59B6).withOpacity(0.4),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ] : [],
                          ),
                          child: Center(
                            child: Text(
                              dates[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),

                // Enhanced Transactions list with better animations
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 600 + (index * 100)),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.03),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Enhanced category icon with glow effect
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            transaction['color'],
                                            transaction['color'].withOpacity(0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: transaction['color'].withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        transaction['icon'],
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),

                                    // Enhanced transaction info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                transaction['category'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  transaction['merchant'],
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            transaction['date'],
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.5),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Enhanced amount with better styling
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: transaction['amount'] > 0
                                            ? Color(0xFF2ECC71).withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: transaction['amount'] > 0
                                              ? Color(0xFF2ECC71).withOpacity(0.3)
                                              : Colors.red.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        transaction['amount'] > 0
                                            ? '+${transaction['amount'].toStringAsFixed(2)}'
                                            : '${transaction['amount'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: transaction['amount'] > 0 ? Color(0xFF2ECC71) : Color(0xFFFF6B6B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Enhanced Bottom summary cards with better design
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Enhanced Cashflow card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9B59B6).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cashflow',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${totalCashflow.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 16),

                          // Enhanced Balance card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF2ECC71).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '+${currentBalance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Enhanced Add transaction button
                      GestureDetector(
                        onTap: () {
                          // Add haptic feedback
                          // HapticFeedback.lightImpact();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'ADD TRANSACTION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodOption(String title, String value) {
    bool isSelected = selectedPeriod == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedPeriod = value);
        fetchTransactionData();
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xFF4AC7D8), Color(0xFF36B5C0)])
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}