import 'dart:convert';
;
import 'package:http/http.dart' as http;

class LoginModel {
  static const String loginUrl = '$API_URL/auth/login';

  static Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usernameOrEmail': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }

    return null;
  }
}
