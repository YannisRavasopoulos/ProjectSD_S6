import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:frontend/data/impl/impl_ride_request.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class FindRideViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  final ActivityRepository activityRepository;

  final List<Activity> activities = [];

  List<Ride> rides = [];
  String? errorMessage;
  bool isLoading = false;

  late final TextEditingController fromController;
  late final TextEditingController toController;

  Location _source = ImplLocation.test('start');
  Location _destination = ImplLocation.test('end');

  String get fromLocation => _source.name;
  String get toLocation => _destination.name;

  String departureTime = 'Now';
  String arrivalTime = 'Soonest';

  static const List<String> _fixedDepartureTimes = [
    'Now',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];
  static const List<String> _fixedArrivalTimes = [
    'Soonest',
    'in 15 minutes',
    'in 30 minutes',
    'Select',
  ];

  List<String> departureTimes;
  List<String> arrivalTimes;

  FindRideViewModel({
    required this.activityRepository,
    required this.rideRepository,
  }) : departureTimes = _fixedDepartureTimes,
       arrivalTimes = _fixedArrivalTimes {
    // Create controllers ONCE in the constructor
    fromController = TextEditingController(text: _source.name);
    toController = TextEditingController(text: _destination.name);

    // Listen for changes and update the model
    fromController.addListener(() {
      setSource(fromController.text, notify: false);
    });
    toController.addListener(() {
      setDestination(toController.text, notify: false);
    });

    fetchRides();
    fetchActivities();
  }

  // Optionally, dispose controllers if you ever dispose the viewmodel
  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void setSource(String sourceName, {bool notify = true}) {
    final match = originLocations.firstWhere(
      (loc) => loc.name.toLowerCase().trim() == sourceName.toLowerCase().trim(),
      orElse: () => originLocations[0],
    );
    _source = match;
    if (notify) {
      fetchRides();
      notifyListeners();
    }
  }

  void setDestination(String destinationName, {bool notify = true}) {
    final match = destinationLocations.firstWhere(
      (loc) => loc.name.toLowerCase() == destinationName.toLowerCase(),
      orElse: () => destinationLocations[1], // fallback
    );
    _destination = match;
    if (notify) {
      fetchRides();
      notifyListeners();
    }
  }

  bool selectingDepartureTime = false;
  bool selectingArrivalTime = false;

  DateTime timeOfDayToString(TimeOfDay t) {
    final now = new DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  void selectActivity(Activity activity) {
    _source = activity.startLocation;
    _destination = activity.endLocation;
    departureTime = timeOfDayToString(activity.startTime).toString();
    arrivalTime = timeOfDayToString(activity.endTime).toString();

    // Reset times to fixed options
    departureTimes = _fixedDepartureTimes;
    arrivalTimes = _fixedArrivalTimes;

    selectingDepartureTime = false;
    selectingArrivalTime = false;

    fetchRides();
    notifyListeners();
  }

  void selectArrivalTime(String? arrivalTime) {
    if (arrivalTime != null) {
      arrivalTimes = _fixedArrivalTimes + [arrivalTime];
      setArrivalTime(arrivalTime);
    } else {
      arrivalTimes = _fixedArrivalTimes;
    }

    selectingArrivalTime = false;
    notifyListeners();
  }

  void selectDepartureTime(String? departureTime) {
    if (departureTime != null) {
      departureTimes = _fixedDepartureTimes + [departureTime];
      setDepartureTime(departureTime);
    } else {
      departureTimes = _fixedDepartureTimes;
    }

    selectingDepartureTime = false;
    notifyListeners();
  }

  void setArrivalTime(String arrivalTime) {
    if (arrivalTime == "Select") {
      selectingArrivalTime = true;
      notifyListeners();
      return;
    }

    this.arrivalTime = arrivalTime;
    fetchRides();
    notifyListeners();
  }

  void setDepartureTime(String departureTime) {
    if (departureTime == "Select") {
      selectingDepartureTime = true;
      notifyListeners();
      return;
    }

    this.departureTime = departureTime;
    fetchRides();
    notifyListeners();
  }

  Future<void> fetchActivities() async {
    try {
      activities.clear();
      final fetchedActivities = await activityRepository.fetch();
      activities.addAll(fetchedActivities);
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchRides() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      rides = await rideRepository.fetchMatchingRides(
        ImplRideRequest(
          id: 0,
          origin: _source,
          destination: _destination,
          departureTime: DateTime.now(),
          arrivalTime: DateTime.now().add(const Duration(hours: 1)),
          originRadius: Distance.withRadius(1000),
          destinationRadius: Distance.withRadius(1000),
          departureWindow: const Duration(minutes: 15),
          arrivalWindow: const Duration(minutes: 15),
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
