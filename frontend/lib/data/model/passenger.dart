import 'package:frontend/data/model/user.dart';

// import 'package:frontend/data/model/pickup.dart';
// import 'package:frontend/data/model/user.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'passenger.g.dart';

abstract class Passenger extends User {}

// @JsonSerializable()
// class Passenger extends User {
//   final Pickup? pickup;

//   const Passenger({
//     required super.id,
//     required super.firstName,
//     required super.lastName,
//     required super.points,
//     this.pickup,
//   });

//   factory Passenger.fromJson(Map<String, dynamic> json) =>
//       _$PassengerFromJson(json);

//   Map<String, dynamic> toJson() => _$PassengerToJson(this);

//   factory Passenger.random() {
//     return Passenger(id: 0, firstName: 'John', lastName: 'Doe', points: 300);
//   }
// }
