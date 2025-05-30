import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';

class OfferRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  final AddressRepository addressRepository;
  final ActivityRepository activityRepository;

  List<Ride> _createdRides = [];
  List<Ride> get createdRides => _createdRides;

  List<Activity> activities;

  List<Passenger> _potentialPassengers = [];
  List<Passenger> get potentialPassengers => _potentialPassengers;

  StreamSubscription<List<Ride>>? _ridesSubscription;
  StreamSubscription<List<User>>? _potentialPassengersSubscription;
  StreamSubscription<List<Activity>>? _activitiesSubscription;

  Ride? _selectedRide;
  Ride? get selectedRide => _selectedRide;

  Activity? _selectedActivity;
  Activity? get selectedActivity => _selectedActivity;

  Address currentAddress;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OfferRideViewModel({
    required this.currentAddress,
    required this.addressRepository,
    required this.rideRepository,
  }) {
    _init();
  }

  void _onRidesUpdated(List<Ride> rides) {
    int? driverId;
    try {
      final currentRide = rideRepository.fetchCurrent();
      driverId = currentRide.driver.id;
    } catch (_) {
      driverId = null;
    }
    if (driverId != null) {
      _createdRides = rides.where((r) => r.driver.id == driverId).toList();
    } else {
      _createdRides = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void _onActivitiesUpdated(List<Activity> activities) {
    this.activities = activities;
  }

  Future<void> _init() async {
    currentAddress = await addressRepository.fetchCurrent();
    activities = await activityRepository.fetch();

    _isLoading = true;
    notifyListeners();

    _ridesSubscription = rideRepository.watchHistory().listen(_onRidesUpdated);
    _activitiesSubscription = activityRepository.watch().listen(
      _onActivitiesUpdated,
    );

    _isLoading = false;
    notifyListeners();
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

  /// Call this when a ride is selected in the UI
  Future<void> selectRide(Ride ride) async {
    _selectedRide = ride;
    _potentialPassengers = [];
    notifyListeners();

    try {
      final user = await rideRepository.fetchPotentialPassengers(ride);
      _potentialPassengers = [user as Passenger];
      // If you want to always add a test passenger for testing:
      _potentialPassengers.add(ImplPassenger.test());
      notifyListeners();
    } catch (_) {
      // If fetch fails, just use a test passenger for testing
      _potentialPassengers = [ImplPassenger.test()];
      notifyListeners();
    }

    // Listen for updates
    _potentialPassengersSubscription?.cancel();
    _potentialPassengersSubscription = rideRepository
        .watchPotentialPassengers(ride)
        .listen((users) {
          _potentialPassengers = users.cast<Passenger>();
          // For testing, always add a test passenger
          _potentialPassengers.add(ImplPassenger.test());
          notifyListeners();
        });
  }

  Future<void> selectActivity(Activity activity) async {
    _selectedActivity = activity;
    _potentialPassengers = [];
    notifyListeners();

    try {
      // Dummy: always return a test passenger for activity
      await Future.delayed(const Duration(milliseconds: 200));
      _potentialPassengers = [ImplPassenger.test()];
      notifyListeners();
    } catch (_) {
      _potentialPassengers = [ImplPassenger.test()];
      notifyListeners();
    }

    // Dummy stream: just yield a test passenger once
    _potentialPassengersSubscription?.cancel();
    _potentialPassengersSubscription = Stream<List<Passenger>>.periodic(
      const Duration(seconds: 5),
      (_) => [ImplPassenger.test()],
    ).listen((users) {
      _potentialPassengers = users;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ridesSubscription?.cancel();
    _potentialPassengersSubscription?.cancel();
    super.dispose();
  }
}
