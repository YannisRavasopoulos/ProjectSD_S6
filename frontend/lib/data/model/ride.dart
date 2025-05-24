import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/route.dart';

abstract class Ride {
  Driver get driver;
  List<Passenger> get passengers;
  Route get route;
  Duration get departureTime;
  DateTime get estimatedArrivalTime;
  Duration get estimatedDuration;
  int get availableSeats;
  int get totalSeats;
}

// import 'package:frontend/data/model.dart';
// import 'package:frontend/data/model/driver.dart';
// import 'package:frontend/data/model/passenger.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'ride.g.dart';

// @JsonSerializable()
// class Ride extends Model {
//   final Driver driver;
//   final List<Passenger> passengers;
//   final DateTime departureTime;

//   const Ride({
//     required super.id,
//     required this.driver,
//     required this.passengers,
//     required this.departureTime,
//   });

//   int get availableSeats => driver.vehicle.capacity - passengers.length - 1;
//   int get totalSeats => driver.vehicle.capacity;

//   factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

//   Map<String, dynamic> toJson() => _$RideToJson(this);

//   factory Ride.random() {
//     return Ride(
//       id: DateTime.now().millisecondsSinceEpoch,
//       driver: Driver.random(),
//       passengers: [],
//       departureTime: DateTime.now(),
//     );
//   }
//   // TODO
//   // final DateTime arrivalTime;
//   // final Route route;
//   // String distance;
//   // String estimatedDuration;
// }
