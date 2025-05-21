import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class RidesListViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  List<Ride> createdRides = [];
  bool isLoading = false;

  RidesListViewModel({required this.rideRepository});

  Future<void> fetchCreatedRides() async {
    isLoading = true;
    notifyListeners();
    createdRides = await rideRepository.fetchCreatedRides();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addRide(Ride ride) async {
    await rideRepository.insertRide(ride);
    await fetchCreatedRides();
  }

  Future<void> removeRide(String id) async {
    await rideRepository.removeRide(id);
    await fetchCreatedRides();
  }
}
