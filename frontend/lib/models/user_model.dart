import 'package:http/http.dart' as http;

import 'dart:convert';

const String API_URL = 'https://api.example.com';

class UserModel {
  String id;
  String password;
  String email;
  String token;

  static const String loginUrl = '$API_URL/auth/login';

  UserModel({
    required this.id,
    required this.password,
    required this.email,
    required this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      password = json['password'],
      email = json['email'],
      token = json['token'];

  static Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usernameOrEmail': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }

    return null;
  }
}
