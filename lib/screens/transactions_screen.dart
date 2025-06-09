import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with TickerProviderStateMixin {
  double balance = 56890.00;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> filteredExpenses = [];
  double monthlySpending = 2890.00;
  double monthlyCashback = 1067.00;
  String username = "Amina";
  bool showBalance = true;
  bool showIncome = true;
  bool isLoading = false;

  late AnimationController _animationController;
  late AnimationController _toggleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _toggleAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    fetchExpenses();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _toggleAnimationController.dispose();
    super.dispose();
  }

  Future<void> fetchExpenses() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      expenses = [
        {
          "name": "Salary Payment from Company Inc.",
          "type": "Income",
          "amount": 4000.00,
          "icon": Icons.account_balance_wallet_rounded,
          "color": Color(0xFF2ECC71),
          "date": "Monthly",
          "description": "Primary monthly salary deposit with bonus included"
        },
        {
          "name": "Stock Dividends Investment",
          "type": "Income",
          "amount": 1000.00,
          "icon": Icons.trending_up_rounded,
          "color": Color(0xFF3498DB),
          "date": "Quarterly",
          "description": "Investment returns from tech stocks portfolio"
        },
        {
          "name": "App Subscriptions Renewal",
          "type": "Outcome",
          "amount": 300.00,
          "icon": Icons.subscriptions_rounded,
          "color": Color(0xFFE74C3C),
          "date": "Monthly",
          "description": "Spotify, Netflix and other digital services"
        },
        {
          "name": "Food & Dining Expenses",
          "type": "Outcome",
          "amount": 1500.00,
          "icon": Icons.restaurant_rounded,
          "color": Color(0xFFFF8A65),
          "date": "Monthly",
          "description": "Restaurants, groceries and coffee shops"
        },
        {
          "name": "Transportation Costs",
          "type": "Outcome",
          "amount": 450.00,
          "icon": Icons.directions_car_rounded,
          "color": Color(0xFF9B59B6),
          "date": "Monthly",
          "description": "Gas, public transport and ride sharing"
        },
        {
          "name": "Freelance Design Work",
          "type": "Income",
          "amount": 800.00,
          "icon": Icons.work_rounded,
          "color": Color(0xFF1ABC9C),
          "date": "Weekly",
          "description": "Client project for mobile app design"
        },
      ];
      applyFilter();
      isLoading = false;
    });
  }

  void applyFilter() {
    setState(() {
      filteredExpenses = expenses.where((expense) =>
      showIncome ? expense["type"] == "Income" : expense["type"] == "Outcome"
      ).toList();
    });
    _toggleAnimationController.forward().then((_) {
      _toggleAnimationController.reverse();
    });
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
                'Loading your transactions...',
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile section
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
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
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667eea).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage('assets/user_profile.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning, $username!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFFFD700).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star_rounded, color: Colors.black, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Premium',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Balance card
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF667eea),
                              Color(0xFF764ba2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF667eea).withOpacity(0.4),
                              blurRadius: 20,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Active Balance',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showBalance = !showBalance;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      showBalance ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Text(
                                showBalance ? '${balance.toStringAsFixed(2)}€' : '•••••••€',
                                key: ValueKey(showBalance),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                // Cashflows button
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
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
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.swap_vert_rounded, color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Cashflows',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                // Simulation button
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF9B59B6).withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.analytics_rounded, color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Simulation',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // View In & Out button
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
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
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'View In & Out',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Transactions section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.03),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Toggle switch for Income/Outcome
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Income toggle option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showIncome = true;
                                        applyFilter();
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: showIncome ? LinearGradient(
                                          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                                        ) : null,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: showIncome ? [
                                          BoxShadow(
                                            color: Color(0xFF2ECC71).withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: Offset(0, 6),
                                          ),
                                        ] : [],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.trending_up_rounded,
                                              color: showIncome ? Colors.white : Colors.grey,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Income',
                                              style: TextStyle(
                                                color: showIncome ? Colors.white : Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Outcome toggle option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showIncome = false;
                                        applyFilter();
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: !showIncome ? LinearGradient(
                                          colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                                        ) : null,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: !showIncome ? [
                                          BoxShadow(
                                            color: Color(0xFFE74C3C).withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: Offset(0, 6),
                                          ),
                                        ] : [],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.trending_down_rounded,
                                              color: !showIncome ? Colors.white : Colors.grey,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Outcome',
                                              style: TextStyle(
                                                color: !showIncome ? Colors.white : Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Expenses list
                          filteredExpenses.isEmpty
                              ? Container(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  showIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  color: Colors.white.withOpacity(0.3),
                                  size: 48,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No ${showIncome ? "income" : "outcome"} transactions found.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                              : Column(
                            children: List.generate(
                              filteredExpenses.length,
                                  (index) {
                                final expense = filteredExpenses[index];
                                return TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 600 + (index * 100)),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, double value, child) {
                                    return Transform.translate(
                                      offset: Offset(0, 30 * (1 - value)),
                                      child: Opacity(
                                        opacity: value,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          padding: EdgeInsets.all(16),
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
                                                blurRadius: 15,
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Category icon
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      expense['color'],
                                                      expense['color'].withOpacity(0.7),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: expense['color'].withOpacity(0.4),
                                                      blurRadius: 12,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  expense['icon'],
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 12),

                                              // Transaction info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      expense['name'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      expense['description'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.6),
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      expense['date'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(0.4),
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 12),

                                              // Amount
                                              Flexible(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: expense['type'] == 'Income'
                                                          ? [
                                                        Color(0xFF2ECC71).withOpacity(0.2),
                                                        Color(0xFF27AE60).withOpacity(0.1)
                                                      ]
                                                          : [
                                                        Color(0xFFE74C3C).withOpacity(0.2),
                                                        Color(0xFFC0392B).withOpacity(0.1)
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: expense['type'] == 'Income'
                                                          ? Color(0xFF2ECC71).withOpacity(0.3)
                                                          : Color(0xFFE74C3C).withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    expense['type'] == 'Income'
                                                        ? '+${expense['amount'].toStringAsFixed(2)}€'
                                                        : '-${expense['amount'].toStringAsFixed(2)}€',
                                                    style: TextStyle(
                                                      color: expense['type'] == 'Income'
                                                          ? Color(0xFF2ECC71)
                                                          : Color(0xFFE74C3C),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Bottom cards - Spendings and Cashback
                    Row(
                      children: [
                        // Spendings card
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2D2D),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Spendings',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${monthlySpending.toStringAsFixed(2)}\€',
                                  style: TextStyle(
                                    color: Colors.deepPurple[300],
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Spent this month',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        // Cashback card
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF4DD0E1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cashback',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${monthlyCashback.toStringAsFixed(2)}\€',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Get this month',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}