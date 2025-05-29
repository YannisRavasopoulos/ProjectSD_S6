import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/route.dart';

class Ride {
  final Driver driver;
  final List<Passenger> passengers;
  final Route route;
  final DateTime departureTime;
  final DateTime estimatedArrivalTime;
  final Duration estimatedDuration;
  final int totalSeats;

  int get availableSeats => totalSeats - passengers.length - 1;

  const Ride({
    required this.driver,
    required this.passengers,
    required this.route,
    required this.departureTime,
    required this.estimatedArrivalTime,
    required this.estimatedDuration,
    required this.totalSeats,
  });
}
