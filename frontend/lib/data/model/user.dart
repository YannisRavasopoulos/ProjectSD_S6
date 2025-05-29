import 'package:frontend/data/model.dart';

abstract class User implements Model {
  String get firstName;
  String get lastName;
  int get points;
  String get name => '$firstName $lastName';
}
