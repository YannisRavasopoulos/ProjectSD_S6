// lib/ui/profile/profile_viewmodel.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final RatingRepository ratingRepository; // Add RatingRepository

  ProfileViewModel({
    required this.userRepository,
    required this.ratingRepository, // Make it required
  });

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
      // Load ratings after user is loaded
      _loadUserRatings(userId);
      notifyListeners(); // Notify listeners when user data is loaded
    } catch (e) {
      // Handle errors (e.g., log them or show a message)
      debugPrint('Error loading user: $e');
    }
  }

  // Add rating-related fields
  double _averageRating = 0.0;
  List<Rating> _userRatings = [];

  // Add rating getters
  double get averageRating => _averageRating;
  List<Rating> get userRatings => List.unmodifiable(_userRatings);

  // Add method to load user ratings
  void _loadUserRatings(int userId) {
    try {
      _userRatings = ratingRepository.getRatingsForUser(userId.toString());
      _averageRating = ratingRepository.getAverageRatingForUser(
        userId.toString(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading ratings: $e');
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

  int get points => user?.points ?? 1200; // Default points set to 1200

  Future<void> updatePoints(int newPoints) async {
    if (user == null) return;
    user!.points = newPoints;
    await userRepository.updateUserPoints(user!.id, newPoints);
    notifyListeners();
  }
}
