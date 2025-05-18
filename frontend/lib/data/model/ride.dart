import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class Ride {
  final String id; // Add this
  final Driver driver;
  final Vehicle vehicle;
  final String distance;
  final String description;
  final String estimatedDuration;
  final int passengers;
  final int capacity;
  final LatLng? pickupLocation; // Add this
  final DateTime? departureTime; // Add this

  Ride({
    required this.id,
    required this.driver,
    required this.vehicle,
    required this.distance,
    required this.description,
    required this.estimatedDuration,
    required this.passengers,
    required this.capacity,
    this.pickupLocation,
    this.departureTime,
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
      id: random.nextInt(100000).toString(), // Random ID for now
      driver: Driver.random(),
      vehicle: Vehicle.random(),
      distance: distances[random.nextInt(distances.length)],
      description: descriptions[random.nextInt(descriptions.length)],
      estimatedDuration: durations[random.nextInt(durations.length)],
      passengers: random.nextInt(4) + 1,
      capacity: 4,
      pickupLocation: null,
      departureTime: DateTime.now().add(
        Duration(minutes: random.nextInt(60)),
      ), // Random departure time within the next hour
    );
  }

  bool get hasAvailableSeats => passengers < capacity;

  Ride copyWith({
    String? id,
    Driver? driver,
    Vehicle? vehicle,
    String? distance,
    String? description,
    String? estimatedDuration,
    int? passengers,
    int? capacity,
    LatLng? pickupLocation,
    DateTime? departureTime,
  }) {
    return Ride(
      id: id ?? this.id,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      distance: distance ?? this.distance,
      description: description ?? this.description,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      passengers: passengers ?? this.passengers,
      capacity: capacity ?? this.capacity,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      departureTime: departureTime ?? this.departureTime,
    );
  }
}
