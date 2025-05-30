class User {
  final int id;
  final String firstName;
  final String lastName;
  final int points;
  String get name => '$firstName $lastName';

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.points,
  });

  factory User.random() {
    return User(id: 0, firstName: 'John', lastName: 'Doe', points: 300);
  }

  User copyWith({int? id, String? firstName, String? lastName, int? points}) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      points: points ?? this.points,
    );
  }
}
