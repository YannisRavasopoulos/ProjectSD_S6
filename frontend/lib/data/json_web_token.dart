import 'dart:convert';

import 'package:frontend/data/authentication.dart';

class JsonWebToken implements Authentication {
  final String token;
  final Map<String, dynamic> header;
  final Map<String, dynamic> payload;

  // https://stackoverflow.com/questions/63941130/flutter-base64-invalid-length-must-be-multiple-of-four-formatexception
  static Map<String, dynamic> _decodeToken(String data) {
    data = base64.normalize(data);
    return jsonDecode(utf8.decode(base64.decode(data)));
  }

  @override
  int get userId {
    return payload['user_id'];
  }

  JsonWebToken(this.token)
    : header = _decodeToken(token.split('.')[0]),
      payload = _decodeToken(token.split('.')[1]);

  JsonWebToken.fromJson(Map<String, dynamic> json) : this(json['token']);

  @override
  Map<String, String> makeHeaders() {
    return {'Authorization': 'Bearer $token'};
  }

  factory JsonWebToken.fake(int userId) {
    final payload = {
      'user_id': userId,
      'exp':
          DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
    };
    final header = {'alg': 'none', 'typ': 'JWT'};
    final token =
        '${base64.encode(utf8.encode(jsonEncode(header)))}.${base64.encode(utf8.encode(jsonEncode(payload)))}.';
    return JsonWebToken(token);
  }
}
