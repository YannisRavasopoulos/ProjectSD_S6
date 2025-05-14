import 'package:frontend/data/model/authentication.dart';
import 'package:frontend/data/model/json_web_token.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/service/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  Future<User> getUser(Authentication authentication) {
    return _userService.getUser(authentication as JsonWebToken);
  }

  Future<void> addUser(User user) async {
    // TODO
    throw UnimplementedError('addUser is not implemented');
  }

  Future<void> updateUser(User user) async {
    // TODO
    throw UnimplementedError('updateUser is not implemented');
  }

  Future<void> removeUser(User user) async {
    // TODO
    throw UnimplementedError('removeUser is not implemented');
  }
}
