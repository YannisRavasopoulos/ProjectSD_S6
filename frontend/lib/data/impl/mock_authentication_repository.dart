import 'package:frontend/data/repository/authentication_repository.dart';

class MockAuthenticationRepository implements AuthenticationRepository {
  @override
  Future<void> authenticate(String email, String password) async {
    // TODO: implement authenticate
  }

  @override
  Future<void> clear() async {
    // TODO: implement clear
    throw UnimplementedError();
  }
}
