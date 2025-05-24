import 'package:flutter/material.dart';
import 'package:frontend/data/mocks/mock_ride_repository.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class CreateRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  CreateRideViewModel({required this.rideRepository});

  String? from;
  String? to;
  TimeOfDay? departureTime;
  int seats = 1;
  int capacity = 4;
  Ride? createdRide;
  Ride? updatedRide;
  int? id;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  void setFrom(String value) {
    from = value;
    notifyListeners();
  }

  void setTo(String value) {
    to = value;
    notifyListeners();
  }

  void setDepartureTime(TimeOfDay value) {
    departureTime = value;
    notifyListeners();
  }

  void setSeats(int value) {
    seats = value;
    notifyListeners();
  }

  void setCapacity(int value) {
    capacity = value;
    notifyListeners();
  }

  Future<void> createRide() async {
    if (from == null || to == null || departureTime == null || seats < 1) {
      errorMessage = "Please fill in all fields.";
      notifyListeners();
      return;
    }
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        departureTime!.hour,
        departureTime!.minute,
      );
      final ride = MockRide(
        driver: MockDriver.random(), // Assuming a random driver for now
        passengers: [],
        route: MockRoute.random(),
        departureTime: dt,
        estimatedArrivalTime: dt.add(Duration(hours: 1)), // Example duration
        estimatedDuration: Duration(hours: 1),
        availableSeats: capacity - seats,
        totalSeats: capacity,
      );

      if (id != null) {
        await rideRepository.update(ride); // <-- EDIT
        successMessage = "Ride updated successfully!";
        updatedRide = ride;
      } else {
        await rideRepository.create(ride); // <-- CREATE
        successMessage = "Ride created successfully!";
        createdRide = ride;
      }
    } catch (e) {
      errorMessage = "Failed to create ride: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
