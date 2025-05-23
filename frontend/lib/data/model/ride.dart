import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride extends Model {
  final Driver driver;
  final List<Passenger> passengers;
  final DateTime departureTime;
  final String from;
  final String to;
  final int seats;

  const Ride({
    required super.id,
    required this.driver,
    required this.passengers,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.seats,
  });

  int get availableSeats => driver.vehicle.capacity - passengers.length - 1;
  int get totalSeats => driver.vehicle.capacity;

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);

  factory Ride.random() {
    return Ride(
      id: DateTime.now().millisecondsSinceEpoch,
      driver: Driver.random(),
      passengers: [],
      departureTime: DateTime.now(),
      from: 'Random From',
      to: 'Random To',
      seats: 4,
    );
  }
  // TODO
  // final DateTime arrivalTime;
  // final Route route;
  // String distance;
  // String estimatedDuration;
}
