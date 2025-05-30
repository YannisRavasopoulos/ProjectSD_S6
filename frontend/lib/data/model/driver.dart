import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/vehicle.dart';

class Driver extends User {
  final Vehicle vehicle;

  Driver({
    required int id,
    required String firstName,
    required String lastName,
    required int points,
    required this.vehicle,
  }) : super(id: id, firstName: firstName, lastName: lastName, points: points);

  factory Driver.test() {
    return Driver(
      id: 0,
      firstName: 'John',
      lastName: 'Doe',
      points: 100,
      vehicle: Vehicle.test(),
    );
  }
}
