import 'package:flutter/material.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  SignInViewModel(this.authenticationRepository, this.userRepository);

  String errorMessage = '';
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  Future<bool> login() async {
    try {
      isLoading = true;
      notifyListeners();

      if (email.isEmpty) {
        errorMessage = 'Email cannot be empty';
        return false;
      }

      if (password.isEmpty) {
        errorMessage = 'Password cannot be empty';
        return false;
      }

      await authenticationRepository.addAuthentication(email, password);

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
