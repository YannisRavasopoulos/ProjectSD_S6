import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';

class ImplDriver extends Driver {
  @override
  final int id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int points;
  @override
  final Vehicle vehicle;

  ImplDriver({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.points,
    required this.vehicle,
  });

  factory ImplDriver.test() {
    return ImplDriver(
      id: 1,
      firstName: 'Test First Name',
      lastName: "Test Last Name",
      points: 999,
      vehicle: ImplVehicle.test(),
    );
  }

  @override
  String toString() {
    return 'ImplDriver{id: $id, name: $name, points: $points, vehicle: $vehicle}';
  }
}
