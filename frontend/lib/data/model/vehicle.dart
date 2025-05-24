// import 'dart:math';

// import 'package:frontend/data/model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'vehicle.g.dart';

// @JsonSerializable()
// class Vehicle extends Model {
//   final String description;
//   final int capacity;

//   const Vehicle({
//     required super.id,
//     required this.description,
//     required this.capacity,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) =>
//       _$VehicleFromJson(json);

//   Map<String, dynamic> toJson() => _$VehicleToJson(this);

//   factory Vehicle.random() {
//     final random = Random();
//     return Vehicle(
//       id: random.nextInt(1000),
//       description: 'Vehicle ${random.nextInt(100)}',
//       capacity: random.nextInt(3) + 2,
//     );
//   }
// }
