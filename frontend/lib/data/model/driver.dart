import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/vehicle.dart';

class Driver extends User {
  final Vehicle vehicle;

  Driver({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.points,
    required this.vehicle,
  });

  factory Driver.fake() {
    return Driver(
      id: 0,
      firstName: 'John',
      lastName: 'Doe',
      points: 100,
      vehicle: Vehicle.fake(),
    );
  }
}
