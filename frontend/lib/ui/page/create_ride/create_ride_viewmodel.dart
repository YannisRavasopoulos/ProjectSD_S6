import 'dart:async';
import 'package:flutter/material.dart' hide Route;
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class CreateRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  // final Ride? initialRide;
  StreamSubscription<List<Ride>>? _ridesSubscription;

  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();

  List<Ride> _rides = [];
  List<Ride> get rides => _rides;

  TimeOfDay? departureTime;
  int seats = 1;
  int capacity = 4;
  Ride? createdRide;
  Ride? updatedRide;
  int? id;
  Address? startLocation;
  Address? endLocation;
  String firstName = "John";
  String lastName = "Doe";
  int points = 300; // Default points for the driver
  Driver? driver;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  CreateRideViewModel({required this.rideRepository}) {
    // if (initialRide != null) {
    //   id = initialRide!.id;
    //   from = initialRide!.route.start.name;
    //   to = initialRide!.route.end.name;
    //   departureTime = TimeOfDay(
    //     hour: initialRide!.departureTime.hour,
    //     minute: initialRide!.departureTime.minute,
    //   );
    //   seats = initialRide!.totalSeats - initialRide!.availableSeats;
    //   capacity = initialRide!.totalSeats;
    //   driver = initialRide!.driver;
    // }
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

  void setFrom(Address start) {
    startLocation = start;
    notifyListeners();
  }

  void setTo(Address end) {
    endLocation = end;
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

  void createInitialRide(Ride initialRide) {
    startLocation = initialRide.route.start;
    endLocation = initialRide.route.end;
    departureTime = TimeOfDay(
      hour: initialRide.departureTime.hour,
      minute: initialRide.departureTime.minute,
    );
    seats = initialRide.totalSeats - initialRide.availableSeats;
    capacity = initialRide.totalSeats;
    driver = initialRide.driver;
    notifyListeners();
  }

  Future<Ride?> saveRide() async {
    if (startLocation == null ||
        endLocation == null ||
        departureTime == null ||
        seats < 1) {
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

      // final startLocation = ImplLocation(
      //   id: DateTime.now().millisecondsSinceEpoch,
      //   coordinates: LatLng(37.0, 23.0),
      //   name: from!,
      // );
      // final endLocation = ImplLocation(
      //   id: DateTime.now().millisecondsSinceEpoch + 1,
      //   coordinates: LatLng(37.5, 23.5),
      //   name: to!,
      // );

      final repo = rideRepository as ImplRideRepository;

      // Await the driver fetch
      Driver driver;
      try {
        final currentRide = await repo.fetchCurrent();
        driver = currentRide.driver;
      } catch (_) {
        // Fallback: create a test driver if none exists
        driver = ImplDriver(
          id: 999,
          firstName: "Test",
          lastName: "Driver",
          vehicle: ImplVehicle(
            id: 1,
            description: "Test Car",
            capacity: capacity,
          ),
          points: 100,
        );
      }

      final route = Route(start: startLocation!, end: endLocation!);

      final ride = Ride(
        driver: driver,
        passengers: [],
        departureTime: dt,
        estimatedArrivalTime: dt.add(const Duration(hours: 1)),
        estimatedDuration: const Duration(hours: 1),
        totalSeats: capacity,
        route: route,
      );

      await rideRepository.create(ride);
      successMessage = "Ride created successfully!";
      createdRide = ride;

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
