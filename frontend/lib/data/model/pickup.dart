import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';

class Pickup {
  final String id;
  final Ride ride;
  final Driver driver;
  final String carpoolerId;
  final DateTime pickupTime;
  final String location;
  final String status;

  const Pickup({
    required this.id,
    required this.ride,
    required this.driver,
    required this.carpoolerId,
    required this.pickupTime,
    required this.location,
    this.status = 'pending',
  });

  // json -> pickup
  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    id: json['id'],
    driver: Driver.fromJson(json['driver']),
    ride: Ride.fromJson(json['ride']), // Add ride deserialization
    carpoolerId: json['carpooler_id'],
    pickupTime: DateTime.parse(json['pickup_time']),
    location: json['location'],
    status: json['status'],
  );

  // pickup -> json
  Map<String, dynamic> toJson() => {
    'id': id,
    'driver': driver,
    'ride': ride.toJson(), // Add ride serialization
    'carpooler_id': carpoolerId,
    'pickup_time': pickupTime.toIso8601String(),
    'location': location,
    'status': status,
  };
}
