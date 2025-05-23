class Transaction {
  final String description;
  final double amount;
  final String currency;

  Transaction({
    required this.description,
    required this.amount,
    required this.currency,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      description: json['description'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
    );
  }
}
