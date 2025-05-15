import 'package:frontend/data/model/authentication.dart';
import 'package:frontend/data/model/json_web_token.dart';

// TODO
class AuthenticationRepository {
  Authentication? _cached;

  Future<void> addAuthentication(String email, String password) async {
    _cached = JsonWebToken.fake(1);
  }

  Future<Authentication?> getAuthentication() async {
    return _cached;
  }

  Future<void> clearAuthentication() async {
    throw UnimplementedError();
  }
}
