import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/service/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  // Fetch user data
  Future<User> getUser(int userId) async {
    return await _userService.getUserById(userId);
  }

  // Update user data
  Future<void> updateUser(User user) async {
    await _userService.updateUser(user);
  }
}
