import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

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
    '15min',
    '30min',
    'Select',
  ];
  static const List<String> _fixedArrivalTimes = [
    'Soonest',
    '15min',
    '30min',
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

    await Future.delayed(Duration(seconds: 1));

    try {
      rides = await rideRepository.getRides(
        source: _source,
        destination: _destination,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
