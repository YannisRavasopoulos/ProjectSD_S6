// lib/ui/profile/profile_viewmodel.dart
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends ChangeNotifier {
  // Profile fields
  String firstName = 'Kwstas';
  String lastName  = 'Loukanaris';
  String email     = 'koslou@gmail.com';
  String password  = 'mySecret123';

  // UI state
  bool isEditing      = false;
  bool showPassword   = false;
  File? profileImage;           // holds picked image file

  //final ImagePicker _picker = ImagePicker();

  void toggleEditing() {
    isEditing = !isEditing;
    // reset password-visibility when you start editing
    if (isEditing == true) showPassword = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }

  // Future<void> pickProfileImage() async {
  //   final picked = await _picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     profileImage = File(picked.path);
  //     notifyListeners();
  //   }
  // }

  // Field updaters
  void updateFirstName(String v) { firstName = v; notifyListeners(); }
  void updateLastName(String v)  { lastName  = v; notifyListeners(); }
  void updateEmail(String v)     { email     = v; notifyListeners(); }
  void updatePassword(String v)  { password  = v; notifyListeners(); }
}
