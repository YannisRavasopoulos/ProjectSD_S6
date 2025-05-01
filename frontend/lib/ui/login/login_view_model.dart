import 'package:flutter/material.dart';
import 'package:frontend/data/login_model.dart';
import 'package:frontend/data/user.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel model;
  String? errorMessage;
  bool isLoading = false;

  LoginViewModel(this.model);

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await LoginModel.login(email, password);
      if (user != null) {
        // Handle successful login (e.g., save user data, navigate, etc.)
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Invalid email or password.";
      }
    } catch (e) {
      errorMessage = "An error occurred. Please try again.";
    }

    isLoading = false;
    notifyListeners();
    return false;
  }
}
