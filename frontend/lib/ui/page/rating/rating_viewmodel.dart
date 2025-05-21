import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/repository/rating_repository.dart';

class RatingViewModel extends ChangeNotifier {
  final RatingRepository ratingRepository;

  int _currentRating = 0;
  String _comment = '';
  bool _isLoading = false;
  String _errorMessage = '';
  List<Rating> _userRatings = [];
  double _averageRating = 0.0;
  RatingViewModel({required this.ratingRepository}) {}

  // Getters

  int get currentRating => _currentRating;
  String get comment => _comment;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Rating> get userRatings => List.unmodifiable(_userRatings);
  bool get canSubmit => _currentRating > 0;
  double get averageRating => getUserAverageRating(1); // Example user ID

  // Update rating value
  void updateRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      _currentRating = rating;
      notifyListeners();
    }
  }

  // Update comment
  void updateComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  // Submit rating
  Future<bool> submitRating({
    required int fromUserId,
    required int toUserId,
    required String rideId,
  }) async {
    if (_currentRating == 0) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await ratingRepository.createRating(
        fromUserId: fromUserId,
        toUserId: toUserId,
        rideId: rideId,
        score: _currentRating,
        comment: _comment.isEmpty ? null : _comment,
      );

      _resetForm();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit rating: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserRatings(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userRatings = ratingRepository.getRatingsForUser(userId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load ratings: $e';
      _userRatings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadRatings(int userId) {
    _userRatings = ratingRepository.getRatingsForUser(userId);
    _averageRating = ratingRepository.getAverageRatingForUser(userId);
  }

  // Get average rating
  double getUserAverageRating(int userId) {
    return ratingRepository.getAverageRatingForUser(userId);
  }

  // Reset form
  void _resetForm() {
    _currentRating = 0;
    _comment = '';
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
