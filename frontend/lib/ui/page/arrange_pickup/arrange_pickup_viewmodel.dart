import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class ArrangePickupViewModel extends ChangeNotifier {
  final PickupRepository _pickupRepository;
  final RideRepository _rideRepository;
  final PickupRequest _pickupRequest;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedTime;
  Location _location = ImplLocation(
    id: 0,
    name: '',
    coordinates: LatLng(0.0, 0.0), // Default coordinates
  );

  ArrangePickupViewModel({
    required PickupRepository pickupRepository,
    required RideRepository rideRepository,
    required PickupRequest pickupRequest,
  })  : _pickupRepository = pickupRepository,
        _rideRepository = rideRepository,
        _pickupRequest = pickupRequest;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedTime => _selectedTime;
  Location get location => _location;

  // Expose data from pickup request
  Ride get ride => _pickupRequest.ride;
  Driver get driver => _pickupRequest.ride.driver;
  int get rideId => _pickupRequest.ride.id;

  // update state
  void setPickupTime(DateTime time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setLocation(Location newLocation) {
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

    if (_location.id == 0 || _location.name.isEmpty) {
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
  if (ride.availableSeats <= 0) {
    _errorMessage = 'No seats available for this ride';
    notifyListeners();
    return false;
  }
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final updatedPassengers = List.of(ride.passengers)
      ..add(_pickupRequest.passenger);

    final updatedRide = ImplRide(
      id: ride.id,
      driver: ride.driver,
      passengers: updatedPassengers,
      route: ride.route,
      totalSeats: ride.totalSeats,
      departureTime: ride.departureTime,
      estimatedDuration: ride.estimatedDuration,
      estimatedArrivalTime: ride.estimatedArrivalTime,
    );

    // Update the ride in the repository
    await _rideRepository.update(updatedRide);

    final pickupProposal = ImplPickup(
      id: _pickupRequest.id,
      ride: updatedRide,
      passenger: _pickupRequest.passenger,
      location: _location,
      time: _selectedTime!,
    );

    await _pickupRepository.acceptPickupRequest(
      _pickupRequest,
      pickupProposal,
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
