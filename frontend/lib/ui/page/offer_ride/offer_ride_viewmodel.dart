import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;

  OfferRideViewModel({required this.rideRepository});

  List<Ride> _createdRides = [];
  List<Ride> get createdRides => _createdRides;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCreatedRides() async {
    _isLoading = true;
    notifyListeners();
    _createdRides = await rideRepository.fetchHistory();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRide(Ride ride) async {
    await rideRepository.create(ride);
    await fetchCreatedRides();
  }

  Future<void> removeRide(Ride ride) async {
    await rideRepository.cancel(ride);
    await fetchCreatedRides();
  }

  // Dummy function for demo
  Future<List<String>> findNearbyCarpoolers(String rideId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ride = _createdRides.firstWhere((r) => r.id.toString() == rideId);
    if (ride == null) return [];
    return List.generate(ride.availableSeats, (i) => 'Carpooler ${i + 1}');
  }
}
