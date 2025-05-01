import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/data/user.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService authenticationService;
  final UserService userService;

  LoginViewModel(this.authenticationService, this.userService);

  String errorMessage = '';
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  Future<bool> login() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      final token = await authenticationService.login(email, password);
      final user = await userService.getUser(token);
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
