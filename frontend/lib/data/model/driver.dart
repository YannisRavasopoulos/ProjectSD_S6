import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/vehicle.dart' show Vehicle;
import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver extends User {
  final Vehicle vehicle;

  const Driver({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.points,
    required this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

  factory Driver.random() {
    return Driver(
      id: 0,
      firstName: 'John',
      lastName: 'Doe',
      points: 300,
      vehicle: Vehicle.random(),
    );
  }
}
