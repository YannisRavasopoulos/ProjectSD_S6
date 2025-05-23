import 'package:frontend/data/model/user.dart';

abstract interface class Rating {
  User get fromUser;
  User get toUser;
  String get comment;
  int get stars;
}
