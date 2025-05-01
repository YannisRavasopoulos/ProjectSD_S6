import 'dart:convert';

import 'package:frontend/config.dart';
import 'package:frontend/data/json_web_token.dart';
import 'package:frontend/data/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final http.Client client;
  UserService({http.Client? client}) : client = client ?? http.Client();

  Future<User> getUser(JsonWebToken token) async {
    final response = await client.get(
      Uri.https(apiDomain, '/user/${token.userId}'),
      headers: token.makeHeaders(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> createUser(User user) async {
    // TODO
    throw UnimplementedError('UserService.createUser is not implemented');
  }

  Future<void> updateUser(User user) async {
    // TODO
    throw UnimplementedError('UserService.updateUser is not implemented');
  }

  Future<void> deleteUser(User user) async {
    // TODO
    throw UnimplementedError('UserService.deleteUser is not implemented');
  }
}
