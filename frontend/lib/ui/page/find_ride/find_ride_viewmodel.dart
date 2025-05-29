import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class FindRideViewModel extends ChangeNotifier {
  FindRideViewModel({
    required ActivityRepository activityRepository,
    required RideRepository rideRepository,
    required AddressRepository addressRepository,
  }) : _activityRepository = activityRepository,
       _rideRepository = rideRepository,
       _addressRepository = addressRepository {
    // Listen for changes and update the model
    fromLocationController.addListener(fetchRides);
    toLocationController.addListener(fetchRides);
    departureTimeController.addListener(fetchRides);
    arrivalTimeController.addListener(fetchRides);

    _init();
  }

  final TextEditingController fromLocationController = TextEditingController();
  final TextEditingController toLocationController = TextEditingController();

  // TODO: default values
  final TextEditingController departureTimeController = TextEditingController(
    text: "Now",
  );
  final TextEditingController arrivalTimeController = TextEditingController(
    text: "Soonest",
  );

  String get fromLocation => fromLocationController.text;
  String get toLocation => toLocationController.text;
  String get departureTime => departureTimeController.text;
  String get arrivalTime => arrivalTimeController.text;

  List<Activity> get activities => _activities;
  String? get errorMessage => _errorMessage;
  List<Ride> get rides => _rides;
  bool get isLoading => _isLoading;

  StreamSubscription<List<Activity>>? _activitiesSubscription;
  List<Activity> _activities = [];
  List<Ride> _rides = [];
  bool _isLoading = false;
  String? _errorMessage;

  final RideRepository _rideRepository;
  final ActivityRepository _activityRepository;
  final AddressRepository _addressRepository;

  void _onActivitiesUpdated(List<Activity> activities) {
    _activities = activities;
    notifyListeners();
  }

  void _init() async {
    // Perform initial fetch
    fetchRides();
    fetchActivities();

    // Subscribe to activity updates
    _activitiesSubscription = _activityRepository.watch().listen(
      _onActivitiesUpdated,
    );
  }

  @override
  void dispose() {
    fromLocationController.dispose();
    toLocationController.dispose();
    departureTimeController.dispose();
    arrivalTimeController.dispose();
    _activitiesSubscription?.cancel();
    super.dispose();
  }

  // Future<void> selectSourceLocation() async {
  // print("SELECT SOURCE");
  // final match = originLocations.firstWhere(
  //   (loc) => loc.name.toLowerCase().trim() == sourceName.toLowerCase().trim(),
  //   orElse: () => originLocations[0],
  // );
  // _source = match;
  // if (notify) {
  //   fetchRides();
  // }
  // notifyListeners();
  // }

  // Future<void> selectDestinationLocation() async {
  // print("SELECT DESTINATION");
  // final match = destinationLocations.firstWhere(
  //   (loc) => loc.name.toLowerCase() == destinationName.toLowerCase(),
  //   orElse: () => destinationLocations[1], // fallback
  // );
  // _destination = match;
  // if (notify) {
  //   fetchRides();
  //   notifyListeners();
  // }
  // notifyListeners();
  // }

  String _timeOfDayToString(TimeOfDay t) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute).toString();
  }

  Future<void> joinRide(Ride ride) async {
    _rideRepository.join(ride);
  }

  Future<void> selectActivity(Activity activity) async {
    var currentAddress = await _addressRepository.fetchCurrent();

    // From should be the current location of the user
    fromLocationController.text = currentAddress.toString();
    toLocationController.text = activity.address.toString();
    departureTimeController.text = "Now";
    arrivalTimeController.text = _timeOfDayToString(activity.startTime);
    await fetchRides();
  }

  Future<void> fetchActivities() async {
    try {
      _activities = await _activityRepository.fetch();
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchRides() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var source = await _addressRepository.fetchForQuery(fromLocation);
      var destination = await _addressRepository.fetchForQuery(toLocation);

      if (source.isEmpty || destination.isEmpty) {
        _errorMessage = "Please provide valid source and destination.";
        return;
      }
      _rides = await _rideRepository.fetchMatchingRides(
        RideRequest(
          origin: source[0],
          destination: destination[0],
          departureTime: DateTime.now(),
          arrivalTime: DateTime.now().add(const Duration(hours: 1)),
          originRadius: Distance.withRadius(1000),
          destinationRadius: Distance.withRadius(1000),
          departureWindow: const Duration(minutes: 15),
          arrivalWindow: const Duration(minutes: 15),
        ),
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
