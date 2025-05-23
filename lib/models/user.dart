import 'package:flowapp/models/transaction.dart' show Transaction;

class User {
  final String name;
  final String email;
  final String accountNumber;
  final double balance;
  final List<Transaction> transactions;

  User({
    required this.name,
    required this.email,
    required this.accountNumber,
    required this.balance,
    required this.transactions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var transactionsList = (json['transactions'] as List)
        .map((item) => Transaction.fromJson(item))
        .toList();

    return User(
      name: json['name'] ?? "Unknown",  // ✅ Avoid null values
      email: json['email'] ?? "",
      accountNumber: json['account_number'],
      balance: json['balance'].toDouble(),
      transactions: transactionsList,
    );
  }
}
