import 'dart:async';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';

class ImplRatingRepository implements RatingRepository {

  final List<Rating> _ratings = [];
  final _ratingController = StreamController<List<Rating>>.broadcast();



  @override
  Future<void> create(Rating rating) async {
    try {
      if (rating.stars < 1 || rating.stars > 5) {
        throw ArgumentError('Rating stars must be between 1 and 5');
      }

      // Check if rating already exists
      final existingRating = _ratings.any((r) => 
        r.fromUser.id == rating.fromUser.id && 
        r.toUser.id == rating.toUser.id
      );

      if (existingRating) {
        throw StateError('Rating already exists for this user pair');
      }

      _ratings.add(rating);
      _notifyListeners(rating.toUser);
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  @override
  Future<void> delete(Rating rating) async {
    try {
      final success = _ratings.remove(rating);
      if (!success) {
        throw StateError('Rating not found');
      }
      _notifyListeners(rating.toUser);
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }

  @override
  Future<List<Rating>> fetch(User user) async {
    try {
      return _ratings
          .where((rating) => rating.toUser.id == user.id)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch ratings: $e');
    }
  }

  @override
  Future<void> update(Rating rating) async {
    try {
      if (rating.stars < 1 || rating.stars > 5) {
        throw ArgumentError('Rating stars must be between 1 and 5');
      }

      final index = _ratings.indexWhere((r) =>
          r.fromUser.id == rating.fromUser.id && 
          r.toUser.id == rating.toUser.id);

      if (index == -1) {
        throw StateError('Rating not found');
      }

      _ratings[index] = rating;
      _notifyListeners(rating.toUser);
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  @override 
  Stream<List<Rating>> watch(User user) async* {
    // Initial data
    _notifyListeners(user);
    // Return stream
    _ratingController.stream.map((ratings) => ratings.where((r) => r.toUser.id == user.id).toList());
  }

  // Helper method to notify listeners of changes
  void _notifyListeners(User user) {
    if (!_ratingController.isClosed) {
      _ratingController.add(_ratings);
    }
  }

  // Clean up resources
  void dispose() {
    _ratingController.close();
  }
}