import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class RateViewModel extends ChangeNotifier {
  final RatingRepository _ratingRepository;
  final UserRepository _userRepository;
  StreamSubscription<List<Rating>>? _ratingsSubscription;

  int _rating = 0;
  String _comment = '';
  bool _isLoading = false;
  String _errorMessage = '';
  User? _currentUser;
  bool _isSuccess = false;

  RateViewModel({
    required RatingRepository ratingRepository,
    required UserRepository userRepository,
  }) : _ratingRepository = ratingRepository,
       _userRepository = userRepository {
    _loadCurrentUser();
  }

  // Getters
  int get rating => _rating;
  String get comment => _comment;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get canSubmit => _rating > 0 && !_isLoading && _currentUser != null;
  bool get isSuccess => _isSuccess;

  @override
  void dispose() {
    _ratingsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _userRepository.fetchCurrent();
      // Start watching ratings after user is loaded
      _watchRatings(_currentUser!);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> submitRating(User toUser) async {
    if (_currentUser == null) {
      _errorMessage = 'User not loaded';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Start watching the target user BEFORE creating the rating
      _watchRatings(toUser); // Watch the user being rated

      final rating = Rating(
        id: DateTime.now().millisecondsSinceEpoch,
        fromUser: _currentUser!,
        toUser: toUser,
        stars: _rating,
        comment: _comment.isEmpty ? null : _comment,
      );

      await _ratingRepository.create(rating);

      // Set loading to false after creation
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _watchRatings(User toUser) {
    _ratingsSubscription?.cancel();
    _ratingsSubscription = _ratingRepository
        .watch(toUser)
        .listen(
          (ratings) {
            // Check if our new rating exists
            final hasNewRating = ratings.any(
              (r) =>
                  r.fromUser.id == _currentUser?.id &&
                  r.toUser.id == toUser.id &&
                  r.stars == _rating,
            );

            if (hasNewRating) {
              _isSuccess = true;
              notifyListeners();
            }
          },
          onError: (error) {
            _errorMessage = error.toString();
            notifyListeners();
          },
        );
  }

  void setRating(double value) {
    _rating = value.toInt();
    _errorMessage = '';
    _isSuccess = false; // Reset success when user changes rating
    notifyListeners();
  }

  void setComment(String value) {
    _comment = value;
    _isSuccess = false; // Reset success when user changes comment
    notifyListeners();
  }

  // Add this method to reset after dialog is closed
  void resetSuccess() {
    _isSuccess = false;
    notifyListeners();
  }
}
