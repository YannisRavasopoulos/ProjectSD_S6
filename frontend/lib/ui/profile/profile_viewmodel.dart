// lib/ui/profile/profile_viewmodel.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  ProfileViewModel({required this.userRepository});

  // Profile fields
  User? user; // Make user nullable to handle loading state
  bool isEditing = false;
  bool showPassword = false;
  File? profileImage;

  // Asynchronous user loading
  Future<void> loadUser(int userId) async {
    if (user != null) return; // Prevent reloading if user is already loaded
    try {
      user = await userRepository.getUser(userId); // Use an asynchronous method
      notifyListeners();
    } catch (e) {
      // Handle errors (e.g., log them or show a message)
      debugPrint('Error loading user: $e');
    }
  }

  void toggleEditing() {
    isEditing = !isEditing;
    if (isEditing) showPassword = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }

  Future<void> saveChanges() async {
    if (user == null) {
      debugPrint('Cannot save changes: user is null');
      return;
    }
    try {
      await userRepository.updateUser(user!); // Persist user data
      toggleEditing();
    } catch (e) {
      // Handle errors (e.g., log them or show a message)
      debugPrint('Error saving changes: $e');
    }
  }

  void updateFirstName(String value) {
    if (user == null) return;
    user!.firstName = value;
    notifyListeners();
  }

  void updateLastName(String value) {
    if (user == null) return;
    user!.lastName = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    if (user == null) return;
    user!.email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    if (user == null) return;
    user!.password = value;
    notifyListeners();
  }
}
