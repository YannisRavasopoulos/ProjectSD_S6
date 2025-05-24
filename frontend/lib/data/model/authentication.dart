import 'package:frontend/data/model.dart';

abstract class Authentication implements Model {
  Map<String, String> makeHeaders();
  int get userId;
}
