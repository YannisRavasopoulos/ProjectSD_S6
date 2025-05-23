import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class RidesViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  List<Ride> createdRides = [];
  bool isLoading = false;

  RidesViewModel({required this.rideRepository});

  Future<void> fetchCreatedRides() async {
    isLoading = true;
    notifyListeners();
    createdRides = await rideRepository.fetch();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateRide(Ride updatedRide) async {
    await rideRepository.update(updatedRide);
    final index = createdRides.indexWhere((r) => r.id == updatedRide.id);
    if (index != -1) {
      createdRides[index] = updatedRide;
      notifyListeners();
    }
  }

  Future<void> addRide(Ride ride) async {
    await rideRepository.create(ride);
    createdRides.add(ride);
    notifyListeners();
  }

  Future<void> removeRide(int id) async {
    await rideRepository.delete(id);
    await fetchCreatedRides();
  }
}
