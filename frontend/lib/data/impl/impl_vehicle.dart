import 'package:frontend/data/model/vehicle.dart';

class ImplVehicle extends Vehicle {
  const ImplVehicle({
    required super.id,
    required super.description,
    required super.capacity,
  });

  factory ImplVehicle.test() {
    return const ImplVehicle(id: 1, description: 'Test Vehicle', capacity: 4);
  }
}
