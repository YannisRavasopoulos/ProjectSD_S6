import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  bool isLoading = false;

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  bool isEditing = false;
  bool showPassword = false;

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void onFirstNameChanged(String value) {
    firstName = value;
    notifyListeners();
  }

  void onLastNameChanged(String value) {
    lastName = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    password = value;
    notifyListeners();
  }

  void onToggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void onSaveChanges() {
    // Save changes logic here
    isEditing = false;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    email = value;
    notifyListeners();
  }

  String get name => '$firstName $lastName';
}
