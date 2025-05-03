class User {
  String id;
  String password;
  String email;

  User({required this.id, required this.password, required this.email});

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      password = json['password'],
      email = json['email'];
}
