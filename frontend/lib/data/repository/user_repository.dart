import 'package:frontend/data/model/user.dart';

abstract interface class UserRepository {
  Future<User> fetchCurrent();
  Stream<User> watchCurrent();
  Future<void> updateCurrentUser(User user);
}
