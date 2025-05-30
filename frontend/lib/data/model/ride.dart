import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/route.dart';

class Ride extends Model {
  final Driver driver;
  final List<Passenger> passengers;
  final Route route;
  final DateTime departureTime;
  final DateTime estimatedArrivalTime;
  final Duration estimatedDuration;
  final int totalSeats;

  int get availableSeats => totalSeats - passengers.length - 1;

  Ride({
    super.id = 0,
    required this.driver,
    required this.passengers,
    required this.route,
    required this.departureTime,
    required this.estimatedArrivalTime,
    required this.estimatedDuration,
    required this.totalSeats,
  });

  factory Ride.fake() {
    return Ride(
      id: 1,
      driver: Driver.fake(),
      passengers: [],
      route: Route.fake(),
      departureTime: DateTime.now().add(Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(Duration(hours: 2)),
      estimatedDuration: Duration(hours: 1),
      totalSeats: 4,
    );
  }
}
