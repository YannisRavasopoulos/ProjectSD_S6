import 'dart:convert';

import 'package:frontend/data/service/json_web_token.dart';
import 'package:http/http.dart' as http;

const apiDomain = 'localhost';

/// This class is responsible for handling authentication-related tasks.
class AuthenticationService {
  static final loginUri = Uri.https(apiDomain, '/auth/login');
  static final logoutUri = Uri.https(apiDomain, '/auth/logout');

  Future<JsonWebToken> login(String username, String password) async {
    final response = await http.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return JsonWebToken.fromJson(jsonDecode(response.body));
    } else {
      throw AuthenticationException('Failed to login');
    }
  }

  Future<void> logout(JsonWebToken token) async {
    final response = await http.post(logoutUri, headers: token.makeHeaders());

    if (response.statusCode != 200) {
      throw AuthenticationException('Failed to logout');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() {
    return 'AuthenticationException: $message';
  }
}
