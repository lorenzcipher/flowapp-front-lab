import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  final ApiService _apiService = ApiService();

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _apiService.getUser();

      if (_user == null) {
        throw Exception("User data is null");
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
