import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';

abstract interface class RatingRepository {
  /// Fetches ratings for a user.
  Future<List<Rating>> fetch(User user);

  /// Watches for changes in ratings for a user.
  Stream<List<Rating>> watch(User user);

  /// Creates a new rating.
  Future<void> create(Rating rating);

  /// Updates an existing rating.
  Future<void> update(Rating rating);

  /// Deletes a rating.
  Future<void> delete(Rating rating);
}
