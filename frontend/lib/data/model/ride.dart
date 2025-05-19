import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/vehicle.dart';
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
      departureTime: DateTime.now().add(
        Duration(minutes: random.nextInt(60)),
      ), // Random departure time within the next hour
    );
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      driver: Driver.fromJson(json['driver']),
      vehicle: Vehicle.fromJson(json['vehicle']),
      distance: json['distance'],
      description: json['description'],
      estimatedDuration: json['estimated_duration'],
      passengers: json['passengers'],
      capacity: json['capacity'],
      departureTime:
          json['departure_time'] != null
              ? DateTime.parse(json['departure_time'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver': driver.toJson(),
      'vehicle': vehicle.toJson(),
      'distance': distance,
      'description': description,
      'estimated_duration': estimatedDuration,
      'passengers': passengers,
      'capacity': capacity,
      'departure_time': departureTime?.toIso8601String(),
    };
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
      departureTime: departureTime ?? this.departureTime,
    );
  }
}
