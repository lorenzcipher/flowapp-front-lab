import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BankViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _bankUrl;
  bool _isLoading = true;
  String? _errorMessage;

  String? get bankUrl => _bankUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> generateBankUrl() async {
    try {
      _bankUrl = await _apiService.generateBankUrl();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
