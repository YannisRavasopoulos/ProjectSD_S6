import 'dart:math';

import 'package:frontend/data/mocks/mock_user_repository.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';

class MockRating extends Rating {
  @override
  final User fromUser;
  @override
  final User toUser;
  @override
  final int stars;
  @override
  final String? comment;
  @override
  final int id;

  MockRating({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.stars,
    this.comment,
  });

  static int _id = 0;

  factory MockRating.random() {
    return MockRating(
      id: _id++,
      fromUser: MockUser.random(),
      toUser: MockUser.random(),
      stars: Random().nextInt(5),
      comment: 'Great ride!',
    );
  }

  // Useful for debugging
  @override
  String toString() {
    return 'Rating(fromUser: ${fromUser.name}, toUser: ${toUser.name}, stars: $stars, comment: $comment)';
  }

  // Useful for comparing ratings
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rating &&
        other.fromUser == fromUser &&
        other.toUser == toUser &&
        other.comment == comment &&
        other.stars == stars;
  }

  @override
  int get hashCode {
    return Object.hash(fromUser, toUser, comment, stars);
  }
}

class MockRatingRepository extends RatingRepository {
  List<Rating> _ratings = List.generate(10, (_) => MockRating.random());

  @override
  Future<List<Rating>> fetch(User user) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _ratings.where((rating) => rating.toUser.id == user.id).toList();
  }

  @override
  Stream<List<Rating>> watch(User user) async* {
    while (true) {
      // Simulate a delay for fetching data
      await Future.delayed(const Duration(seconds: 10));
      yield await fetch(user);
    }
  }

  // TODO

  @override
  Future<void> create(Rating rating) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if rating already exists
    final exists = _ratings.any(
      (r) =>
          r.fromUser.id == rating.fromUser.id &&
          r.toUser.id == rating.toUser.id,
    );

    if (!exists) {
      _ratings.add(rating);
    }
  }

  @override
  Future<void> update(Rating rating) async {
    final index = _ratings.indexWhere(
      (r) =>
          r.fromUser.id == rating.fromUser.id &&
          r.toUser.id == rating.toUser.id,
    );

    if (index != -1) {
      _ratings[index] = rating;
    }
  }

  @override
  Future<void> delete(Rating rating) async {
    _ratings.removeWhere(
      (r) =>
          r.fromUser.id == rating.fromUser.id &&
          r.toUser.id == rating.toUser.id,
    );
  }
}
