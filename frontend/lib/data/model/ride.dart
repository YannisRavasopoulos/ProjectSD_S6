import 'package:frontend/data/model/driver.dart';
import 'dart:math';

import 'package:frontend/data/model/vehicle.dart';

// TODO
class Ride {
  Driver driver;
  Vehicle vehicle;
  String distance;
  String description;
  String estimatedDuration;
  int passengers;
  int capacity;

  Ride({
    required this.driver,
    required this.vehicle,
    required this.distance,
    required this.description,
    required this.estimatedDuration,
    required this.passengers,
    required this.capacity,
  });

  factory Ride.random() {
    final random = Random();
    final distances = ["5 km", "10 km", "15 km", "20 km"];
    final descriptions = [
      "Heading to the city center",
      "Going to the airport",
      "Visiting the park",
      "Driving to the mall",
    ];
    final durations = ["15 minutes", "30 minutes", "45 minutes", "1 hour"];

    return Ride(
      driver: Driver.random(),
      vehicle: Vehicle.random(),
      distance: distances[random.nextInt(distances.length)],
      description: descriptions[random.nextInt(descriptions.length)],
      estimatedDuration: durations[random.nextInt(durations.length)],
      passengers: random.nextInt(4) + 1, // Random passengers between 0 and 3
      capacity: 4,
    );
  }
}
