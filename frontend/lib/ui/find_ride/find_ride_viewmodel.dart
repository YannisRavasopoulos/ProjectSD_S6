import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class FindRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;

  List<Ride> _rides = [];
  List<Ride> get rides => _rides;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _source = '';
  String _destination = '';

  FindRideViewModel({required this.rideRepository}) {
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

  void setArrivalTime(String? arrivalTime) {
    // Handle arrival time selection
    fetchRides();
    notifyListeners();
  }

  void setDepartureTime(String? departureTime) {
    // Handle departure time selection
    fetchRides();
    notifyListeners();
  }

  Future<void> fetchRides() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    try {
      _rides = await rideRepository.getRides(
        source: _source,
        destination: _destination,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
