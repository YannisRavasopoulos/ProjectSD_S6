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

  MockRating({
    required this.fromUser,
    required this.toUser,
    required this.stars,
    this.comment,
  });

  factory MockRating.random() {
    return MockRating(
      fromUser: MockUser.random(),
      toUser: MockUser.random(),
      stars: Random().nextInt(5),
      comment: 'Great ride!',
    );
  }
}

class MockRatingRepository extends RatingRepository {
  List<Rating> _ratings = List.generate(10, (_) => MockRating.random());

  @override
  Future<List<Rating>> fetch(User user) async {
    return _ratings;
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
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Future<void> update(Rating rating) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Future<void> delete(Rating rating) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
  }
}
