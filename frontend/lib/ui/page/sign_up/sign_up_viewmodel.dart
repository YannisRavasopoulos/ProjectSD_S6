import 'package:flutter/material.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/ui/view.dart';

class SignUpViewModel extends ViewModel {
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // https://stackoverflow.com/questions/35392798/regex-to-validate-full-name-having-atleast-four-characters
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$');

  final RegExp _passwordRegex = RegExp(r'^.{8,}$');

  bool get isEmailValid => _emailRegex.hasMatch(email);
  bool get isNameValid => _nameRegex.hasMatch(name);
  bool get isPasswordValid => _passwordRegex.hasMatch(password);
  bool get doPasswordsMatch => password == confirmPassword;

  String get email => emailController.text.trim();
  String get name => nameController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  SignUpViewModel({required this.userRepository}) {
    emailController.addListener(notifyListeners);
    nameController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final UserRepository userRepository;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
