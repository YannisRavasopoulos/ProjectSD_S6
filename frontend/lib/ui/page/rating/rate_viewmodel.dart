import 'package:flutter/material.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/rating_impl.dart';

class RateViewModel extends ChangeNotifier {
  final RatingRepository _ratingRepository;
  final UserRepository _userRepository;

  int _rating = 0;
  String _comment = '';
  bool _isLoading = false;
  String _errorMessage = '';
  User? _currentUser;

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

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _userRepository.fetch();
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

  Future<void> submitRating(User userToRate) async {
    if (_currentUser == null) {
      _errorMessage = 'User not loaded';
      notifyListeners();
      return;
    }

    if (_rating == 0) {
      _errorMessage = 'Please select a rating';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _ratingRepository.create(
        RatingImpl(
          fromUser: _currentUser!,
          toUser: userToRate,
          comment: _comment,
          stars: _rating,
        ),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to submit rating: ${e.toString()}';
      notifyListeners();
    }
  }
}
