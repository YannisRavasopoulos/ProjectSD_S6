import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/rating.dart';

class RatingImpl implements Rating {
  @override
  final User fromUser;

  @override
  final User toUser;

  @override
  final String comment;

  @override
  final int stars;

  const RatingImpl({
    required this.fromUser,
    required this.toUser,
    required this.comment,
    required this.stars,
  });

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
