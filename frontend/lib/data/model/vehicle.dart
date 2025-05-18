import 'dart:math';

class Vehicle {
  String description;

  Vehicle({required this.description});

  factory Vehicle.random() {
    final descriptions = [
      "Toyota Camry",
      "Honda Civic",
      "Ford Focus",
      "BMW 3 Series",
    ];
    final random = Random();
    return Vehicle(
      description: descriptions[random.nextInt(descriptions.length)],
    );
  }
}
