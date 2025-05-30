import 'package:frontend/data/model/model.dart';

class Reward extends Model {
  final int points;
  final String title;
  final String description;

  Reward({
    required this.description,
    required super.id,
    required this.points,
    required this.title,
  });
}
