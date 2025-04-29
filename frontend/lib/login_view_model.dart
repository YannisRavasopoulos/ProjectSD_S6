import 'package:flutter/material.dart';
import 'package:frontend/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel model;
  String? errorMessage;

  LoginViewModel(this.model);
}
