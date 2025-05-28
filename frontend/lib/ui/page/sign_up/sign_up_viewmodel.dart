import 'package:flutter/material.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/ui/viewmodel.dart';

abstract interface class SignUpViewModelInterface {
  bool get isEmailValid;
  bool get isNameValid;
  bool get isPasswordValid;
  bool get doPasswordsMatch;
  bool get canSignUp;

  String get email;
  String get name;
  String get password;
  String get confirmPassword;

  TextEditingController get emailController;
  TextEditingController get nameController;
  TextEditingController get passwordController;
  TextEditingController get confirmPasswordController;

  Future<bool> signUp();

  void togglePasswordVisibility();
  void toggleConfirmPasswordVisibility();
}

class SignUpViewModel extends ViewModel implements SignUpViewModelInterface {
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // https://stackoverflow.com/questions/35392798/regex-to-validate-full-name-having-atleast-four-characters
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$');

  final RegExp _passwordRegex = RegExp(r'^.{8,}$');

  @override
  bool get isEmailValid => _emailRegex.hasMatch(email);
  @override
  bool get isNameValid => _nameRegex.hasMatch(name);
  @override
  bool get isPasswordValid => _passwordRegex.hasMatch(password);
  @override
  bool get doPasswordsMatch => password == confirmPassword;
  @override
  bool get canSignUp =>
      isEmailValid && isNameValid && isPasswordValid && doPasswordsMatch;

  @override
  String get email => emailController.text.trim();
  @override
  String get name => nameController.text.trim();
  @override
  String get password => passwordController.text;
  @override
  String get confirmPassword => confirmPasswordController.text;

  @override
  final TextEditingController emailController = TextEditingController();

  @override
  final TextEditingController nameController = TextEditingController();

  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpViewModel({required this.userRepository}) {
    emailController.addListener(notifyListeners);
    nameController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final UserRepository userRepository;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isLoading = false;
  String errorMessage = '';

  @override
  Future<bool> signUp() async {
    isLoading = true;
    notifyListeners();

    // TODO: Implement sign-up logic
    errorMessage = "Not implemented yet";

    isLoading = false;
    notifyListeners();
    return false;
  }

  @override
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  @override
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }
}
