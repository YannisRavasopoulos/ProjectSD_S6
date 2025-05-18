import 'dart:async';
import 'package:frontend/data/model/user.dart';

class UserService {
  // Simulate fetching user data by ID
  Future<UserProfile> getUserById(int userId) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return UserProfile.dummy(); // Return dummy user profile
  }

  // Simulate updating user data
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    print('User updated: ${user.toJson()}'); // Log updated user data
  }
}
