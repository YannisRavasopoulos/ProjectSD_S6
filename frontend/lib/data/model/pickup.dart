import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pickup.g.dart';

enum PickupStatus { pending, accepted, completed, cancelled }

@JsonSerializable()
class Pickup extends Model {
  final Driver driver;
  final Passenger passenger;
  final Ride ride;
  final DateTime time;
  final Location location;
  final PickupStatus status;

  const Pickup({
    required super.id,
    required this.location,
    required this.status,
    required this.driver,
    required this.passenger,
    required this.ride,
    required this.time,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) => _$PickupFromJson(json);

  Map<String, dynamic> toJson() => _$PickupToJson(this);

  factory Pickup.random() {
    return Pickup(
      id: 1,
      location: Location.random(),
      status: PickupStatus.values[0],
      driver: Driver.random(),
      passenger: Passenger.random(),
      ride: Ride.random(),
      time: DateTime.now(),
    );
  }
}
