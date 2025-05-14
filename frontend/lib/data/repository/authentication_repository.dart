import 'package:frontend/data/model/authentication.dart';
import 'package:frontend/data/service/authentication_service.dart';

// TODO
class AuthenticationRepository {
  final AuthenticationService _authenticationService = AuthenticationService();

  Authentication? _cached;

  Future<void> createAuthentication(String email, String password) async {
    _cached = await _authenticationService.login(email, password);
  }

  Future<Authentication> getAuthentication() async {
    return _cached!;
  }

  Future<void> clearAuthentication() async {
    throw UnimplementedError();
  }
}
