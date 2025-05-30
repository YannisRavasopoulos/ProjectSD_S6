import 'package:frontend/data/model/user.dart';

class Rating {
  final int id;
  final User fromUser;
  final User toUser;
  final int stars;
  final String? comment;

  Rating({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.stars,
    this.comment,
  });
}
