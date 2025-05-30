import 'dart:async';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';

class ImplRatingRepository implements RatingRepository {
  // Change to non-final and initialize with dummy data
  final List<Rating> _ratings = [
    Rating(
      id: 1,
      fromUser: User(
        id: 101,
        firstName: "Emma",
        lastName: "Watson",
        points: 120,
      ),
      toUser: User(id: 0, firstName: "John", lastName: "Doe", points: 150),
      stars: 5,
      comment: "Very punctual and friendly driver!",
    ),
    Rating(
      id: 2,
      fromUser: User(
        id: 102,
        firstName: "Michael",
        lastName: "Chen",
        points: 85,
      ),
      toUser: User(id: 0, firstName: "John", lastName: "Doe", points: 150),
      stars: 4,
      comment: "Good conversation, made the journey enjoyable",
    ),
    Rating(
      id: 3,
      fromUser: User(
        id: 103,
        firstName: "Sophie",
        lastName: "Martinez",
        points: 95,
      ),
      toUser: User(id: 0, firstName: "John", lastName: "Doe", points: 150),
      stars: 5,
      comment: "Great music selection and comfortable ride",
    ),
    Rating(
      id: 4,
      fromUser: User(id: 104, firstName: "David", lastName: "Kim", points: 75),
      toUser: User(id: 0, firstName: "John", lastName: "Doe", points: 150),
      stars: 4,
      comment: "Safe driver, would ride again",
    ),
    Rating(
      id: 5,
      fromUser: User(
        id: 105,
        firstName: "Aisha",
        lastName: "Patel",
        points: 110,
      ),
      toUser: User(id: 0, firstName: "John", lastName: "Doe", points: 150),
      stars: 5,
      comment: "Very professional and friendly",
    ),
  ];

  final _ratingController = StreamController<List<Rating>>.broadcast();

  @override
  Future<void> create(Rating rating) async {
    if (rating.stars < 1 || rating.stars > 5) {
      return Future.error('Rating stars must be between 1 and 5');
    }

    final index = _ratings.indexWhere((r) => r.id == rating.id);
    if (index != -1) {
      throw Exception('Rating with this ID already exists');
    }

    // Check if rating already exists
    final existingRating = _ratings.any(
      (r) =>
          r.fromUser.id == rating.fromUser.id &&
          r.toUser.id == rating.toUser.id,
    );

    if (existingRating) {
      throw Exception('Rating already exists for this user pair');
    }

    _ratings.add(rating);
    _notifyListeners(rating.toUser);
  }

  @override
  Future<void> delete(Rating rating) async {
    try {
      final success = _ratings.remove(rating);
      if (!success) {
        return Future.error('Rating not found');
      }
      _notifyListeners(rating.toUser);
    } catch (e) {
      return Future.error('Failed to delete rating: $e');
    }
  }

  @override
  Future<List<Rating>> fetch(User user) async {
    try {
      return _ratings.where((rating) => rating.toUser.id == user.id).toList();
    } catch (e) {
      return Future.error('Failed to fetch ratings: $e');
    }
  }

  @override
  Future<void> update(Rating rating) async {
    try {
      if (rating.stars < 1 || rating.stars > 5) {
        return Future.error('Rating stars must be between 1 and 5');
      }

      final index = _ratings.indexWhere(
        (r) =>
            r.fromUser.id == rating.fromUser.id &&
            r.toUser.id == rating.toUser.id,
      );

      if (index == -1) {
        return Future.error('Rating not found');
      }

      _ratings[index] = rating;
      _notifyListeners(rating.toUser);
    } catch (e) {
      return Future.error('Failed to update rating: $e');
    }
  }

  @override
  Stream<List<Rating>> watch(User user) async* {
    try {
      yield List.unmodifiable(
        _ratings.where((r) => r.toUser.id == user.id).toList(),
      );
      yield* _ratingController.stream.map(
        (ratings) => ratings.where((r) => r.toUser.id == user.id).toList(),
      );
    } catch (e) {
      yield* Stream.error('Failed to watch ratings: $e');
    }
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
