import 'package:frontend/data/model/user.dart';

abstract interface class UserRepository {
  Future<User> fetchCurrent();
  Future<void> updateCurrentUser(User user);
  Stream<User> watchCurrent();
}
