import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class RidesViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  StreamSubscription<List<Ride>>? _ridesSubscription;

  List<Ride> _allRides = [];
  List<Ride> get allRides => _allRides;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  RidesViewModel({required this.rideRepository}) {
    _init();
  }

  void _init() {
    _isLoading = true;
    notifyListeners();
    _ridesSubscription = rideRepository.watchHistory().listen(
      (rides) {
        _allRides = rides;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<Ride> get createdRides {
    final currentUser = (rideRepository as ImplRideRepository).currentUser;
    if (currentUser == null) return [];
    return _allRides.where((ride) => ride.driver.id == currentUser.id).toList();
  }

  Future<void> updateRide(Ride updatedRide) async {
    _isLoading = true;
    notifyListeners();
    try {
      await rideRepository.update(updatedRide);
    } catch (e) {
      errorMessage = "Failed to update ride: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRide(Ride ride) async {
    _isLoading = true;
    notifyListeners();
    try {
      await rideRepository.create(ride);
    } catch (e) {
      errorMessage = "Failed to add ride: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeRide(Ride ride) async {
    _isLoading = true;
    notifyListeners();
    try {
      await rideRepository.cancel(ride);
    } catch (e) {
      errorMessage = "Failed to remove ride: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ridesSubscription?.cancel();
    super.dispose();
  }
}
