import 'package:flutter/material.dart';
import 'package:frontend/data/impl/implemented_ride_repository.dart';
import 'package:frontend/data/impl/mock_location_repository.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class FindRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;

  List<Ride> rides = [];
  String? errorMessage;
  bool isLoading = false;

  String _source = '';
  String _destination = '';

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

  void setSource(String source) {
    _source = source;
    fetchRides();
    notifyListeners();
  }

  void setDestination(String destination) {
    _destination = destination;
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
        ImplementedRideRequest(
          origin: MockLocation(coordinates: LatLng(0, 0)),
          destination: MockLocation(coordinates: LatLng(0, 0)),
          departureTime: DateTime.now(),
          arrivalTime: DateTime.now().add(Duration(hours: 1)),
          id: 1,
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
