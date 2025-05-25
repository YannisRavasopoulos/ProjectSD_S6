import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

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
  Location? startLocation;
  Location? endLocation;

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

      final startLocation = LocationImpl(
        id: DateTime.now().millisecondsSinceEpoch,
        coordinates: LatLng(37.0, 23.0),
        name: from!,
      );
      final endLocation = LocationImpl(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        coordinates: LatLng(37.5, 23.5),
        name: to!,
      );

      final route = ImplementedRoute(
        id: DateTime.now().millisecondsSinceEpoch,
        start: startLocation,
        end: endLocation,
      );

      final ride = RideImpl(
        id: DateTime.now().millisecondsSinceEpoch,
        driver: ImplementedDriver(
          id: 1,
          firstName: 'Demo',
          lastName: 'Driver',
          points: 100,
        ),
        passengers: [],
        route: route,
        departureTime: dt,
        estimatedArrivalTime: dt.add(const Duration(hours: 1)),
        estimatedDuration: const Duration(hours: 1),
        availableSeats: capacity - seats,
        totalSeats: capacity,
      );

      await rideRepository.create(ride);
      successMessage = "Ride created successfully!";
      createdRide = ride;
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
