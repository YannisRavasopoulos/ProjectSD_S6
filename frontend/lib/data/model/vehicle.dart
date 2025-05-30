import 'package:frontend/data/model/model.dart';

class Vehicle extends Model {
  final String description;
  final int capacity;

  Vehicle({
    required super.id,
    required this.description,
    required this.capacity,
  });

  factory Vehicle.fake() {
    return Vehicle(id: 1, description: 'Test Vehicle', capacity: 4);
  }
}
