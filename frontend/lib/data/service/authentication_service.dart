import 'dart:convert';

import 'package:frontend/config.dart';
import 'package:frontend/data/authentication_exception.dart';
import 'package:frontend/data/json_web_token.dart';
import 'package:http/http.dart' as http;

/// This class is responsible for handling authentication-related tasks.
class AuthenticationService {
  static final loginUri = Uri.https(apiDomain, '/auth/login');
  static final logoutUri = Uri.https(apiDomain, '/auth/logout');
  static final refreshUri = Uri.https(apiDomain, '/auth/refresh');

  final http.Client client;

  /// Creates an instance of [AuthenticationService] with an optional HTTP client.
  /// If no client is provided, a new one will be created.
  AuthenticationService({http.Client? client})
    : client = client ?? http.Client();

  /// Authenticates a user with their username (email) and password.
  ///
  /// Makes a POST request to the login endpoint with the provided credentials.
  ///
  /// Returns a [JsonWebToken] if authentication is successful.
  ///
  /// Throws an [AuthenticationException] if the login fails.
  ///
  /// Parameters:
  /// - [username]: The user's email address
  /// - [password]: The user's password
  Future<JsonWebToken> login(String username, String password) async {
    final response = await client.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return JsonWebToken(jsonDecode(response.body)['token']);
    } else {
      throw AuthenticationException('Failed to login');
    }
  }

  /// Refreshes an authentication token.
  ///
  /// Makes a POST request to the refresh endpoint with the current token.
  ///
  /// Returns a new [JsonWebToken] if the refresh is successful.
  ///
  /// Throws an [AuthenticationException] if the token refresh fails.
  ///
  /// Parameters:
  /// - [token]: The current JWT to refresh
  Future<JsonWebToken> refresh(JsonWebToken token) async {
    final response = await http.post(refreshUri, headers: token.makeHeaders());

    if (response.statusCode == 200) {
      return JsonWebToken.fromJson(jsonDecode(response.body));
    } else {
      throw AuthenticationException('Failed to refresh token');
    }
  }

  /// Logs out a user by invalidating their token.
  ///
  /// Makes a POST request to the logout endpoint with the current token.
  ///
  /// Throws an [AuthenticationException] if the logout fails.
  ///
  /// Parameters:
  /// - [token]: The JWT to invalidate
  Future<void> logout(JsonWebToken token) async {
    final response = await http.post(logoutUri, headers: token.makeHeaders());

    if (response.statusCode != 200) {
      throw AuthenticationException('Failed to logout');
    }
  }
}
