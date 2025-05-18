import 'dart:convert';

import 'package:frontend/config.dart';
import 'package:frontend/data/authentication_exception.dart';
import 'package:frontend/data/model/json_web_token.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final http.Client client;

  AuthenticationService({http.Client? client})
    : client = client ?? http.Client();

  Future<JsonWebToken> login(String username, String password) async {
    final response = await client.post(
      Uri.https(apiDomain, '/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return JsonWebToken.fromJson(jsonDecode(response.body));
    } else {
      throw AuthenticationException('Failed to login');
    }
  }

  Future<JsonWebToken> refresh(JsonWebToken token) async {
    final response = await http.post(
      Uri.https(apiDomain, '/auth/refresh'),
      headers: token.makeHeaders(),
    );

    if (response.statusCode == 200) {
      return JsonWebToken.fromJson(jsonDecode(response.body));
    } else {
      throw AuthenticationException('Failed to refresh token');
    }
  }

  Future<void> logout(JsonWebToken token) async {
    final response = await http.post(
      Uri.https(apiDomain, '/auth/logout'),
      headers: token.makeHeaders(),
    );

    if (response.statusCode != 200) {
      throw AuthenticationException('Failed to logout');
    }
  }
}
