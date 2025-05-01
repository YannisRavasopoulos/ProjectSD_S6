import 'package:http/http.dart' as http;

import 'dart:convert';

class User {
  String id;
  String password;
  String email;
  String token;

  User({
    required this.id,
    required this.password,
    required this.email,
    required this.token,
  });

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      password = json['password'],
      email = json['email'],
      token = json['token'];
}
