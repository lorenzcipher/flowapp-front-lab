import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TransactionItem(icon: Icons.credit_card, text: "40832-810-5-7000-012345"),
          TransactionItem(icon: Icons.euro, text: "18 199.24 EUR"),
          TransactionItem(icon: Icons.attach_money, text: "36.67 GBP"),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const TransactionItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
