import 'dart:async';
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
  StreamSubscription<List<Ride>>? _ridesSubscription;

  List<Ride> _rides = [];
  List<Ride> get rides => _rides;

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

  CreateRideViewModel({this.initialRide, required this.rideRepository}) {
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
    _init();
  }

  void _init() {
    _ridesSubscription = rideRepository.watchHistory().listen(
      (rides) {
        _rides = rides;
        notifyListeners();
      },
      onError: (error) {
        errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _ridesSubscription?.cancel();
    super.dispose();
  }

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
        id: DateTime.now().millisecondsSinceEpoch,
        coordinates: LatLng(37.0, 23.0),
        name: from!,
      );
      final endLocation = ImplLocation(
        name: to!,
        id: DateTime.now().millisecondsSinceEpoch + 1,
        coordinates: LatLng(37.5, 23.5),
      );

      final repo = rideRepository as ImplRideRepository;
      if (repo.currentUser == null) {
        repo.currentUser = ImplUser(
          id: 1,
          firstName: "Default",
          lastName: "User",
          points: 300,
        );
      }
      final driver = repo.currentUser!; // <-- το ίδιο instance

      final route = ImplRoute(
        id: id ?? DateTime.now().millisecondsSinceEpoch,
        start: startLocation,
        end: endLocation,
      );

      final rideId =
          id ?? initialRide?.id ?? DateTime.now().millisecondsSinceEpoch;

      final ride = ImplRide(
        id: rideId,
        driver: driver as Driver, // <-- το ίδιο instance
        passengers: [],
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

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
