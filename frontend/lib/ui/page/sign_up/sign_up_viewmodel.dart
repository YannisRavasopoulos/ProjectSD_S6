import 'package:flutter/material.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/ui/viewmodel.dart';

class SignUpViewModel extends ViewModel {
  SignUpViewModel({required UserRepository userRepository})
    : _userRepository = userRepository {
    emailController.addListener(notifyListeners);
    nameController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  bool get isEmailValid => _emailRegex.hasMatch(email);
  bool get isNameValid => _nameRegex.hasMatch(name);
  bool get isPasswordValid => _passwordRegex.hasMatch(password);
  bool get doPasswordsMatch => password == confirmPassword;
  bool get canSignUp =>
      isEmailValid && isNameValid && isPasswordValid && doPasswordsMatch;
  String get email => emailController.text.trim();
  String get name => nameController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isLoading => _isLoading;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<bool> signUp() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement sign-up logic
      throw UnimplementedError('Sign-up logic is not implemented yet.');
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  final UserRepository _userRepository;
  final RegExp _passwordRegex = RegExp(r'^.{8,}$');
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // https://stackoverflow.com/questions/35392798/regex-to-validate-full-name-having-atleast-four-characters
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$');
}
