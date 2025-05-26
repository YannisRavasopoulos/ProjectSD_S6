import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class CreateRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  final Ride? initialRide;

  CreateRideViewModel({required this.rideRepository, this.initialRide}) {
    if (initialRide != null) {
      id = initialRide!.id;
      from = initialRide!.route.start.name;
      to = initialRide!.route.end.name;
      departureTime = TimeOfDay(
        hour: initialRide!.departureTime.hour,
        minute: initialRide!.departureTime.minute,
      );
      seats = initialRide!.totalSeats - initialRide!.availableSeats;
      capacity = initialRide!.totalSeats;
      driver = initialRide!.driver;
    }
  }

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
  String firstName = "John";
  String lastName = "Doe";
  int points = 300; // Default points for the driver
  Driver? driver;

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

  Future<Ride?> saveRide() async {
    if (from == null || to == null || departureTime == null || seats < 1) {
      errorMessage = "Please fill in all fields.";
      notifyListeners();
      return null;
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

      final startLocation = ImplLocation(
        id:
            initialRide?.route.start.id ??
            DateTime.now().millisecondsSinceEpoch,
        coordinates: LatLng(37.0, 23.0),
        name: from!,
      );
      final endLocation = ImplLocation(
        name: to!,
        id:
            initialRide?.route.end.id ??
            DateTime.now().millisecondsSinceEpoch + 1,
        coordinates: LatLng(37.5, 23.5),
      );

      final driver =
          initialRide?.driver ??
          ImplUser(
            id: id ?? DateTime.now().millisecondsSinceEpoch,
            firstName: firstName,
            lastName: lastName,
            points: points,
          );

      final route = ImplRoute(
        id:
            initialRide?.route.id ??
            id ??
            DateTime.now().millisecondsSinceEpoch,
        start: startLocation,
        end: endLocation,
      );

      final ride = ImplRide(
        id: initialRide?.id ?? id ?? DateTime.now().millisecondsSinceEpoch,
        driver: driver as Driver,
        passengers: initialRide?.passengers ?? [],
        departureTime: dt,
        estimatedArrivalTime: dt.add(const Duration(hours: 1)),
        estimatedDuration: const Duration(hours: 1),
        availableSeats: capacity - seats,
        totalSeats: capacity,
        route: route,
      );

      if (initialRide != null) {
        await rideRepository.update(ride);
        successMessage = "Ride updated successfully!";
        updatedRide = ride;
      } else {
        await rideRepository.create(ride);
        successMessage = "Ride created successfully!";
        createdRide = ride;
      }
      return ride;
    } catch (e) {
      errorMessage = "Failed to save ride: $e";
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Ride?> buildRide() async {
    if (from == null || to == null || departureTime == null || seats < 1) {
      errorMessage = "Please fill in all fields.";
      notifyListeners();
      return null;
    }
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      departureTime!.hour,
      departureTime!.minute,
    );

    final startLocation = ImplLocation(
      id: initialRide?.route.start.id ?? DateTime.now().millisecondsSinceEpoch,
      coordinates: LatLng(37.0, 23.0),
      name: from!,
    );
    final endLocation = ImplLocation(
      name: to!,
      id:
          initialRide?.route.end.id ??
          DateTime.now().millisecondsSinceEpoch + 1,
      coordinates: LatLng(37.5, 23.5),
    );

    final driver =
        initialRide?.driver ??
        ImplUser(
          id: id ?? DateTime.now().millisecondsSinceEpoch,
          firstName: firstName,
          lastName: lastName,
          points: points,
        );

    final route = ImplRoute(
      id: initialRide?.route.id ?? id ?? DateTime.now().millisecondsSinceEpoch,
      start: startLocation,
      end: endLocation,
    );

    final ride = ImplRide(
      id: initialRide?.id ?? id ?? DateTime.now().millisecondsSinceEpoch,
      driver: driver as Driver,
      passengers: initialRide?.passengers ?? [],
      departureTime: dt,
      estimatedArrivalTime: dt.add(const Duration(hours: 1)),
      estimatedDuration: const Duration(hours: 1),
      availableSeats: capacity - seats,
      totalSeats: capacity,
      route: route,
    );
    return ride;
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
