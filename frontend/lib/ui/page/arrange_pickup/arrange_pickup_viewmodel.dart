import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/repository/pickup_repository.dart';

class ArrangePickupViewModel extends ChangeNotifier {
  final PickupRepository _repository;
  final PickupRequest _pickupRequest;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedTime;
  Address? _address;

  ArrangePickupViewModel({
    required PickupRepository repository,
    required PickupRequest pickupRequest,
  }) : _repository = repository,
       _pickupRequest = pickupRequest;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedTime => _selectedTime;
  Address? get address => _address;

  // Expose data from pickup request
  Ride get ride => _pickupRequest.ride;
  Driver get driver => _pickupRequest.ride.driver;
  int get rideId => _pickupRequest.ride.id;

  // update state
  void setPickupTime(DateTime time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setLocation(Address newAddress) {
    _address = newAddress;
    notifyListeners();
  }

  // Validate pickup details
  bool isValid() {
    if (_selectedTime == null) {
      _errorMessage = 'Please select a pickup time';
      notifyListeners();
      return false;
    }

    if (_address == null) {
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
  Future<bool> arrangePickup() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final pickupProposal = Pickup(
        ride: _pickupRequest.ride,
        passenger: _pickupRequest.passenger,
        address: _address!,
        time: _selectedTime!,
      );

      await _repository.acceptPickupRequest(_pickupRequest, pickupProposal);

      _isLoading = false;
      notifyListeners();

      return true; // Success if pickup is created
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to arrange pickup: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
