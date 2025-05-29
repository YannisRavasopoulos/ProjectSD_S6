import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel();

  String errorMessage = '';
  bool isLoading = false;
  bool isPasswordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> login() async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: more validation

      if (email.isEmpty) {
        errorMessage = 'Email cannot be empty';
        return false;
      }

      if (password.isEmpty) {
        errorMessage = 'Password cannot be empty';
        return false;
      }

      // TODO
      // await authenticationRepository.authenticate(email, password);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
