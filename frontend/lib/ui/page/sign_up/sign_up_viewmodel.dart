import 'package:flutter/material.dart';
import 'package:frontend/data/repository/user_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(this.userRepository) {
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  UserRepository userRepository;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String get email => emailController.text;
  String get name => nameController.text;
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool get doPasswordsMatch =>
      password.isNotEmpty && password == confirmPassword;

  bool isLoading = false;
  String errorMessage = '';

  void signUp() {
    isLoading = true;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }
}
