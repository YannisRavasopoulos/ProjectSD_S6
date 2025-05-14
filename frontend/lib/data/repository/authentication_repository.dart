import 'package:frontend/data/model/user.dart';

abstract interface class AuthenticationToken {
  Map<String, String> makeHeaders();
  int get userId;
}

abstract interface class AuthenticationInfo {
  String get email;
  String get password;
}

abstract interface class AuthenticationRepository {
  AuthenticationToken getToken(AuthenticationInfo info);
}

abstract interface class UserRepository {
  User getUser(int id);
}

class MyAuthenticationRepository implements AuthenticationRepository {
  @override
  AuthenticationToken getToken(AuthenticationInfo info) {
    throw UnimplementedError('getToken is not implemented');
  }
}
