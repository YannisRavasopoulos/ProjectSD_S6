import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/shared/datetime_selector.dart';
import 'package:frontend/ui/shared/text_address_selector.dart';
import 'package:latlong2/latlong.dart';

class FindRideViewModel extends ChangeNotifier {
  FindRideViewModel({
    required ActivityRepository activityRepository,
    required RideRepository rideRepository,
    required this.addressRepository,
  }) : _activityRepository = activityRepository,
       _rideRepository = rideRepository {
    // Listen for changes and update the model
    departureTimeController.addListener(fetchRides);
    arrivalTimeController.addListener(fetchRides);

    _init();
  }

  // TODO: default values
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();

  Address? get fromAddress => _fromAddress;
  Address? get toAddress => _toAddress;
  String get departureTime => departureTimeController.text;
  String get arrivalTime => arrivalTimeController.text;

  List<Activity> get activities => _activities;
  String? get errorMessage => _errorMessage;
  List<Ride> get rides => _rides;
  bool get isLoading => _isLoading;
  Address? _fromAddress;
  Address? _toAddress;
  DateTime? _departureTime;
  DateTime? _arrivalTime;

  StreamSubscription<List<Activity>>? _activitiesSubscription;
  List<Activity> _activities = [];
  List<Ride> _rides = [];
  bool _isLoading = false;
  String? _errorMessage;

  final GlobalKey<TextAddressSelectorState> fromAddressSelectorKey =
      GlobalKey<TextAddressSelectorState>();

  final GlobalKey<TextAddressSelectorState> toAddressSelectorKey =
      GlobalKey<TextAddressSelectorState>();

  final GlobalKey<DateTimeSelectorState> departureTimeSelectorKey =
      GlobalKey<DateTimeSelectorState>();

  final GlobalKey<DateTimeSelectorState> arrivalTimeSelectorKey =
      GlobalKey<DateTimeSelectorState>();

  final RideRepository _rideRepository;
  final ActivityRepository _activityRepository;
  final AddressRepository addressRepository;

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
    departureTimeController.dispose();
    arrivalTimeController.dispose();
    _activitiesSubscription?.cancel();
    super.dispose();
  }

  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );
  }

  Future<void> selectActivity(Activity activity) async {
    var currentAddress = await addressRepository.fetchCurrent();

    fromAddressSelectorKey.currentState?.setAddress(currentAddress);
    toAddressSelectorKey.currentState?.setAddress(activity.address);

    departureTimeSelectorKey.currentState?.setDateTime(DateTime.now());
    arrivalTimeSelectorKey.currentState?.setDateTime(
      _timeOfDayToDateTime(activity.startTime),
    );

    selectFromAddress(currentAddress);
    selectToAddress(activity.address);

    selectDepartureTime(DateTime.now());
    selectArrivalTime(_timeOfDayToDateTime(activity.startTime));

    await fetchRides();
  }

  Future<void> selectFromAddress(Address address) async {
    print("Selected from address: $address");
    _fromAddress = address;
    await fetchRides();
  }

  Future<void> selectToAddress(Address address) async {
    print("Selected to address: $address");
    _toAddress = address;
    await fetchRides();
  }

  Future<void> selectDepartureTime(DateTime? time) async {
    print("Selected departure time: $time");
    _departureTime = time;
    await fetchRides();
  }

  Future<void> selectArrivalTime(DateTime? time) async {
    print("Selected arrival time: $time");
    _arrivalTime = time;
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
      if (fromAddress == null || toAddress == null) {
        _errorMessage = "Please provide valid source and destination.";
        return;
      }

      if (_departureTime == null || _arrivalTime == null) {
        _errorMessage = "Please select valid departure and arrival times.";
        return;
      }

      _rides = await _rideRepository.fetchMatchingRides(
        RideRequest(
          origin: fromAddress!,
          destination: toAddress!,
          departureTime: _departureTime!,
          arrivalTime: _arrivalTime!,
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
