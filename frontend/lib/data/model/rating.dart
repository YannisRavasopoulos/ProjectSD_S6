class Rating {
  final int id;
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

  factory Rating.random() {
    final score = (1 + (5 - 1) * (0.5)).toInt();
    final comment = 'This is a random comment';
    final createdAt = DateTime.now();

    return Rating(
      id: 0,
      fromUserId: 1,
      toUserId: 2,
      rideId: 'x',
      score: score,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
