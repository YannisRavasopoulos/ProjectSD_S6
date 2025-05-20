class Rating {
  final String id;
  final int fromUserId;
  final int toUserId;
  final String rideId;
  final int score;
  final String? comment;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.rideId,
    required this.score,
    this.comment,
    required this.createdAt,
  });
}
