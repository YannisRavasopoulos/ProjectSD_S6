import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:frontend/data/impl/impl_ride_request.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class FindRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;

  List<Ride> rides = [];
  String? errorMessage;
  bool isLoading = false;

  Location _source = ImplLocation.test('status: start');
  Location _destination = ImplLocation.test('status: end');

  String departureTime = 'Now';
  String arrivalTime = 'Soonest';

  static const List<String> _fixedDepartureTimes = [
    'Now',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];
  static const List<String> _fixedArrivalTimes = [
    'Soonest',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];

  List<String> departureTimes;
  List<String> arrivalTimes;

  FindRideViewModel({required this.rideRepository})
    : departureTimes = _fixedDepartureTimes,
      arrivalTimes = _fixedArrivalTimes {
    fetchRides();
  }

  void setSource(String sourceName) {
    final match = patrasLocations.firstWhere(
      (loc) => loc.name.toLowerCase() == sourceName.toLowerCase(),
      orElse: () => patrasLocations[0], // fallback
    );
    _source = match;
    fetchRides();
    notifyListeners();
  }

  void setDestination(String destinationName) {
    final match = patrasLocations.firstWhere(
      (loc) => loc.name.toLowerCase() == destinationName.toLowerCase(),
      orElse: () => patrasLocations[1], // fallback
    );
    _destination = match;
    fetchRides();
    notifyListeners();
  }

  bool selectingDepartureTime = false;
  bool selectingArrivalTime = false;

  void selectArrivalTime(String? arrivalTime) {
    if (arrivalTime != null) {
      arrivalTimes = _fixedArrivalTimes + [arrivalTime];
      setArrivalTime(arrivalTime);
    } else {
      arrivalTimes = _fixedArrivalTimes;
    }

    selectingArrivalTime = false;
    notifyListeners();
  }

  void selectDepartureTime(String? departureTime) {
    if (departureTime != null) {
      departureTimes = _fixedDepartureTimes + [departureTime];
      setDepartureTime(departureTime);
    } else {
      departureTimes = _fixedDepartureTimes;
    }

    selectingDepartureTime = false;
    notifyListeners();
  }

  void setArrivalTime(String arrivalTime) {
    if (arrivalTime == "Select") {
      selectingArrivalTime = true;
      notifyListeners();
      return;
    }

    this.arrivalTime = arrivalTime;
    fetchRides();
    notifyListeners();
  }

  void setDepartureTime(String departureTime) {
    if (departureTime == "Select") {
      selectingDepartureTime = true;
      notifyListeners();
      return;
    }

    this.departureTime = departureTime;
    fetchRides();
    notifyListeners();
  }

  Future<void> fetchRides() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: fetch Matching rides
      rides = await rideRepository.fetchMatchingRides(
        ImplRideRequest(
          id: 0,
          origin: ImplLocation.test('status: start'),
          destination: ImplLocation.test('status: end'),
          departureTime: DateTime.now(),
          arrivalTime: DateTime.now().add(const Duration(hours: 1)),
          originRadius: Distance.withRadius(1000), // 1 km radius
          destinationRadius: Distance.withRadius(1000), // 1 km radius
          departureWindow: const Duration(minutes: 15),
          arrivalWindow: const Duration(minutes: 15),
        ),
      );
      // rides = await rideRepository.fetchAllRides(); //Applied for testing the repo access
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
