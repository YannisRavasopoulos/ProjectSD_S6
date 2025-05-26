import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  StreamSubscription<List<Ride>>? _ridesSubscription;

  List<Ride> _createdRides = [];
  List<Ride> get createdRides => _createdRides;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OfferRideViewModel({required this.rideRepository}) {
    _init();
  }

  void _init() {
    _isLoading = true;
    notifyListeners();
    _ridesSubscription = rideRepository.watchHistory().listen(
      (rides) {
        final currentUser = (rideRepository as ImplRideRepository).currentUser;
        if (currentUser != null) {
          _createdRides =
              rides.where((r) => r.driver.id == currentUser.id).toList();
        } else {
          _createdRides = [];
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _createdRides = [];
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addRide(Ride ride) async {
    _isLoading = true;
    notifyListeners();
    await rideRepository.create(ride);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeRide(Ride ride) async {
    _isLoading = true;
    notifyListeners();
    await rideRepository.cancel(ride);
    _isLoading = false;
    notifyListeners();
  }

  // Dummy function for demo
  Future<List<String>> findNearbyCarpoolers(String rideId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ride = _createdRides.firstWhere((r) => r.id.toString() == rideId);
    if (ride == null) return [];
    return List.generate(ride.availableSeats, (i) => 'Carpooler ${i + 1}');
  }

  @override
  void dispose() {
    _ridesSubscription?.cancel();
    super.dispose();
  }
}
