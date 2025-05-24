import 'package:frontend/data/model.dart';

abstract class User implements Model {
  String get firstName;
  String get lastName;
  int get points;
  String get name => '$firstName $lastName';
}

// import 'package:frontend/data/model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'user.g.dart';

// @JsonSerializable()
// class User extends Model {
//   final String firstName;
//   final String lastName;
//   // TODO
//   // WE SHOULD NOT STORE EMAILS/PASSWORDS
//   // final String email;
//   // final String password;
//   final int points;

//   const User({
//     required super.id,
//     required this.firstName,
//     required this.lastName,
//     required this.points,
//   });

//   get name => '$firstName $lastName';

//   User copyWith({int? id, String? firstName, String? lastName, int? points}) {
//     return User(
//       id: id ?? 0,
//       firstName: firstName ?? '',
//       lastName: lastName ?? '',
//       points: points ?? 0,
//     );
//   }

//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

//   Map<String, dynamic> toJson() => _$UserToJson(this);

//   factory User.random() {
//     return User(id: 0, firstName: 'John', lastName: 'Doe', points: 300);
//   }
// }
