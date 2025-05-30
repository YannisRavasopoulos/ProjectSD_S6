import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/user.dart';

class Rating extends Model {
  final User fromUser;
  final User toUser;
  final int stars;
  final String? comment;

  Rating({
    required super.id,
    required this.fromUser,
    required this.toUser,
    required this.stars,
    this.comment,
  });
}
