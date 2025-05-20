import 'package:frontend/data/model/rating.dart';

class RatingRepository {
  final List<Rating> _ratings = [
    Rating(
      id: '1',
      fromUserId: 2,
      toUserId: 1,
      rideId: 'ride_123',
      score: 5,
      comment: 'Great driver, very punctual!',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Rating(
      id: '2',
      fromUserId: 3,
      toUserId: 1,
      rideId: 'ride_124',
      score: 4,
      comment: 'Pleasant journey, would ride again',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Rating(
      id: '3',
      fromUserId: 1,
      toUserId: 2,
      rideId: 'ride_125',
      score: 5,
      comment: 'Perfect passenger, very friendly',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Rating(
      id: '4',
      fromUserId: 4,
      toUserId: 1,
      rideId: 'ride_126',
      score: 3,
      comment: 'Decent ride but was a bit late',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<Rating> createRating({
    required int fromUserId,
    required int toUserId,
    required String rideId,
    required int score,
    String? comment,
  }) async {
    final rating = Rating(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      rideId: rideId,
      score: score,
      comment: comment,
      createdAt: DateTime.now(),
    );

    _ratings.add(rating);
    return rating;
  }

  List<Rating> getRatingsForUser(String userId) {
    // Return all ratings instead of filtering
    return List<Rating>.from(_ratings);
  }

  // Get average rating score for a user
  double getAverageRatingForUser(String userId) {
    final userRatings = getRatingsForUser(userId);
    if (userRatings.isEmpty) return 0.0;

    final sum = userRatings.fold(0, (sum, rating) => sum + rating.score);
    return sum / userRatings.length;
  }

  List<Rating> getRatingsForRide(String rideId) {
    return _ratings.where((rating) => rating.rideId == rideId).toList();
  }
}
