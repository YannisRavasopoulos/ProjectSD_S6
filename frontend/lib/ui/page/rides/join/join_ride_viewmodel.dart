import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class JoinRideViewModel extends ChangeNotifier {
  final Ride ride;
  final RideRepository rideRepository;
  final PickupRepository pickupRepository;

  bool _isArrangingPickup = false;
  bool _hasJoinedRide = false;
  bool isLoading = false;
  String? errorMessage;
  Pickup? pickup;
  bool get isArrangingPickup => _isArrangingPickup;
  bool get hasJoinedRide => _hasJoinedRide;

  JoinRideViewModel({
    required this.ride,
    required this.pickupRepository,
    required this.rideRepository,
  });

  Future<PickupRequest?> joinRide() async {
    errorMessage = null;
    notifyListeners();

    try {
      await rideRepository.join(ride);
      _hasJoinedRide = true;
      _isArrangingPickup = true;

      notifyListeners();

      final pickupRequest = PickupRequest(
        id: 0,
        ride: ride,
        passenger: Passenger.test(),
        address: Address.fake(),
        time: DateTime.now(),
      );
      pickup = await pickupRepository.requestPickup(pickupRequest);
      _isArrangingPickup = false;
      isLoading = false;
      notifyListeners();
      return pickupRequest;
    } catch (e) {
      errorMessage = 'Failed to join ride: $e';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
