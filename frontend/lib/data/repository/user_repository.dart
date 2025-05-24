import 'package:frontend/data/model/user.dart';

abstract class UserRepository {
  Future<User> fetchCurrent();
  Stream<User> watchCurrent();
}
