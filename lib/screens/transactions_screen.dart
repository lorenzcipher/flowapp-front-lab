import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  double balance = 56890.00;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> filteredExpenses = [];
  double monthlySpending = 2890.00;
  double monthlyCashback = 1067.00;
  String username = "Amina";
  bool showBalance = true;
  bool showIncome = true; // Toggle between Income and Outcome

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    // Simulating API call
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      expenses = [
        {"name": "Salary", "type": "Income", "amount": 4000.00},
        {"name": "Stock Dividens", "type": "Income", "amount": 1000.00},
        {"name": "App Subscriptions", "type": "Outcome", "amount": 300.00},
        {"name": "Food & Dining", "type": "Outcome", "amount": 1500.00},
      ];
      applyFilter();
    });
  }

  void applyFilter() {
    setState(() {
      filteredExpenses = expenses.where((expense) =>
      showIncome ? expense["type"] == "Income" : expense["type"] == "Outcome"
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User profile section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/user_profile.png'),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Morning, $username!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),

                // Balance card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.deepPurple.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Active Balance',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.visibility,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        '${balance.toStringAsFixed(2)}\€',
                        style: TextStyle(
                          color: Color(0xFF4DD0E1),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          // Cashflows button
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4DD0E1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  'Cashflows',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          // Simulation button
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  'Simulation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // View In & Out button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.keyboard_arrow_down),
                        SizedBox(width: 5),
                        Text('View In & Out'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Expenses section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Expenses',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      // Toggle switch for Income/Outcome
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(30),
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
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: showIncome ? Color(0xFF4DD0E1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Income',
                                      style: TextStyle(
                                        color: showIncome ? Colors.black : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !showIncome ? Colors.deepPurple[400] : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Outcome',
                                      style: TextStyle(
                                        color: !showIncome ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),

                      // Expenses list
                      filteredExpenses.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No ${showIncome ? "income" : "outcome"} transactions found.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                // Category name
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      expense['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Type (Income/Outcome)

                                // Amount
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${expense['amount'].toStringAsFixed(2)}\€',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

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
    );
  }
}