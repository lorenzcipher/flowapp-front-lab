import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double balance;
  final String accountNumber;

  const CardWidget({
    Key? key,
    required this.balance,
    required this.accountNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "€ ${balance.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            accountNumber,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "VALID DATE\n08/24",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
