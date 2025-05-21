import 'package:flutter/material.dart';
import 'package:frontend/data/repository/user_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel({required this.userRepository}) {
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final UserRepository userRepository;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String get email => emailController.text;
  String get name => nameController.text;
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool get doPasswordsMatch => password == confirmPassword;

  bool isLoading = false;
  String errorMessage = '';

  Future<bool> signUp() async {
    isLoading = true;
    notifyListeners();

    // TODO: Implement sign-up logic
    errorMessage = "Not implemented yet";

    isLoading = false;
    notifyListeners();
    return false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }
}
