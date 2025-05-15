import 'package:frontend/data/model/user.dart';
import 'dart:math';

class RideParticipant /* extends User */ {
  String name;

  RideParticipant({required this.name});

  factory RideParticipant.random() {
    final names = ["John Doe", "Jane Smith", "Alice Johnson", "Bob Brown"];
    final random = Random();
    return RideParticipant(name: names[random.nextInt(names.length)]);
  }
}

class Driver extends RideParticipant {
  Driver({required String name}) : super(name: name);

  factory Driver.random() {
    return Driver(name: RideParticipant.random().name);
  }
}

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

class Passenger extends RideParticipant {
  Passenger({required String name}) : super(name: name);

  factory Passenger.random() {
    return Passenger(name: RideParticipant.random().name);
  }
}

class Location {}

class DateTime {}

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
