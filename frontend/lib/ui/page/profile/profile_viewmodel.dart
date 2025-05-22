import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  bool isLoading = false;

  String firstName = 'First';
  String lastName = 'Last';
  String email = 'mail';
  String password = 'perfectpassword';
  bool isEditing = false;

  void toggleEditing() {
    isEditing = !isEditing;
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

  void saveChanges() {
    // Save changes logic here
    isEditing = false;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    email = value;
    notifyListeners();
  }
}
