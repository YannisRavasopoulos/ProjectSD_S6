import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/user.dart';

abstract class Rating implements Model {
  User get fromUser;
  User get toUser;
  String? get comment;
  int get stars;
}
