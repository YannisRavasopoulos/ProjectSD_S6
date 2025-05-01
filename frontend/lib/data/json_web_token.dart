import 'dart:convert';

class JsonWebToken {
  final String token;

  Map<String, String> get header {
    final header = token.split('.')[0];
    final decodedHeader = String.fromCharCodes(base64Url.decode(header));
    return jsonDecode(decodedHeader);
  }

  Map<String, String> get payload {
    final payload = token.split('.')[1];
    final decodedPayload = String.fromCharCodes(base64Url.decode(payload));
    return jsonDecode(decodedPayload);
  }

  int get userId {
    return int.parse(payload['userId'] ?? '');
  }

  JsonWebToken(this.token);

  Map<String, String> makeHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization:': 'Bearer $token',
    };
  }
}
