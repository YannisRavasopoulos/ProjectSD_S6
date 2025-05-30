import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final RideRepository _rideRepository;
  final Ride _ride;

  List<User> potentialPassengers = [];

  bool isLoading = true;

  StreamSubscription<List<User>>? _potentialPassengersSubscription;

  OfferRideViewModel({
    required RideRepository rideRepository,
    required Ride ride,
  }) : _rideRepository = rideRepository,
       _ride = ride {
    _init();
    _potentialPassengersSubscription = rideRepository
        .watchPotentialPassengers(ride)
        .listen(_onPotentialPassengersUpdated);
  }

  void _init() async {
    await fetchPotentialPassengers();
    isLoading = false;
    notifyListeners();
  }

  void _onPotentialPassengersUpdated(List<User> passengers) {
    potentialPassengers = passengers;
    notifyListeners();
  }

  Future<void> fetchPotentialPassengers() async {
    potentialPassengers = await _rideRepository.fetchPotentialPassengers(_ride);
    notifyListeners();
  }

  @override
  void dispose() {
    _potentialPassengersSubscription?.cancel();
    super.dispose();
  }

  Future<PickupRequest> offerRide(User potentialPassenger) async {
    return _rideRepository.offer(_ride, potentialPassenger);
  }
}
