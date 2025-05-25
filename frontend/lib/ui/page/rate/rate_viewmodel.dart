import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_rating_repository.dart';
import 'package:frontend/data/mocks/mock_rating_repository.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class RateViewModel extends ChangeNotifier {
  final RatingRepository _ratingRepository;
  final UserRepository _userRepository;

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

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _userRepository.fetchCurrent();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user: ${e.toString()}';
      notifyListeners();
    }
  }

  void setRating(double value) {
    _rating = value.toInt();
    _errorMessage = '';
    notifyListeners();
  }

  void setComment(String value) {
    _comment = value;
    notifyListeners();
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
      final rating = ImplRating(
        id: DateTime.now().millisecondsSinceEpoch,
        fromUser: _currentUser!,
        toUser: toUser,
        stars: _rating,
        comment: _comment.isEmpty ? null : _comment,
      );

      await _ratingRepository.create(rating);
      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
