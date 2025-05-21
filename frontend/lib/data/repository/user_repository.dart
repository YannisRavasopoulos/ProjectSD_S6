import 'package:frontend/data/model/user.dart';

class UserRepository {
  // Fetch user data
  Future<User> getUser(int userId) async {
    return User.random();
  }

  // Update user data
  Future<void> updateUser(User user) async {}

  Future<void> updateUserPoints(int userId, int points) async {}

  Future<int> getUserPoints(int userId) async {
    return 500;
  }
}
