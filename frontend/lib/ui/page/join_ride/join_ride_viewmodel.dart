import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_address_repository.dart';
import 'package:frontend/data/impl/impl_passenger.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/repository/pickup_repository.dart';

class JoinRideViewModel extends ChangeNotifier {
  final Ride ride;
  final PickupRepository pickupRepository;

  bool isLoading = false;
  String? errorMessage;
  Pickup? pickup;

  JoinRideViewModel({required this.ride, required this.pickupRepository});

  Future<PickupRequest?> joinRide() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final pickupRequest = PickupRequest(
        id: DateTime.now().millisecondsSinceEpoch,
        ride: ride,
        passenger: ImplPassenger.test(),
        address: Address.fake(),
        time: DateTime.now(),
      );
      pickup = await pickupRepository.requestPickup(pickupRequest);
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
