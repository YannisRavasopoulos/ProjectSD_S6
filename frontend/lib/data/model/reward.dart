import 'package:frontend/data/model.dart';

abstract class Reward implements Model {
  String get title;
  String get description;
  int get points;
}
