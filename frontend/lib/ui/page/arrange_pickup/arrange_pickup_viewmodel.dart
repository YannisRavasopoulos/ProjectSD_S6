import 'package:frontend/data/model/ride.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/model/driver.dart';

class ArrangePickupViewModel extends ChangeNotifier {
  final ImplPickupRepository _repository;
  final Driver _driver;
  final int _rideId;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedTime;
  String _location = '';

  ArrangePickupViewModel({
    required ImplPickupRepository repository,
    required Driver driver,
    required int rideId,
  }) : _repository = repository,
       _driver = driver,
       _rideId = rideId;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedTime => _selectedTime;
  String get location => _location;
  Driver get driver => _driver;
  int get rideId => _rideId;

  // update state
  void setPickupTime(DateTime time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setLocation(String newLocation) {
    _location = newLocation;
    notifyListeners();
  }

  // Validate pickup details
  bool isValid() {
    if (_selectedTime == null) {
      _errorMessage = 'Please select a pickup time';
      notifyListeners();
      return false;
    }

    if (_location.isEmpty) {
      _errorMessage = 'Please select a pickup location';
      notifyListeners();
      return false;
    }

    // Check if pickup time is in the future
    if (_selectedTime!.isBefore(DateTime.now())) {
      _errorMessage = 'Pickup time must be in the future';
      notifyListeners();
      return false;
    }

    return true;
  }

  // business logic
  Future<bool> arrangePickup({
    required String carpoolerId,
    required Driver driver,
    required Ride ride,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _repository.createPickupRequest(
        carpoolerId: carpoolerId,
        driver: driver,
        ride: ride,
        pickupTime: _selectedTime!,
        location: _location,
      );

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to arrange pickup: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
