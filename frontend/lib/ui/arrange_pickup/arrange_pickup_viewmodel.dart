import 'package:frontend/data/model/ride.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/model/driver.dart';

class ArrangePickupViewModel extends ChangeNotifier {
  final PickupRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedTime;
  String _location = '';

  ArrangePickupViewModel({
    required PickupRepository repository,
    required Driver driver,
    required String rideId,
  }) : _repository = repository;

  // state access
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedTime => _selectedTime;
  String get location => _location;

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
    if (_selectedTime == null || _location.isEmpty) {
      _errorMessage = 'Please select both time and location';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.createPickupRequest(
        carpoolerId: carpoolerId,
        driver: driver,
        ride: ride, // Assuming driver has a ride property,
        pickupTime: _selectedTime!,
        location: _location,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to arrange pickup: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
