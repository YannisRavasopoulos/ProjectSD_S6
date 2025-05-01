class JsonWebToken {
  final String token;

  JsonWebToken(this.token);

  JsonWebToken.fromJson(Map<String, dynamic> json) : token = json['token'];

  Map<String, String> makeHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization:': 'Bearer $token',
    };
  }
}
