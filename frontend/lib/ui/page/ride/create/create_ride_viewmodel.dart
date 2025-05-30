import 'dart:async';
import 'package:flutter/material.dart' hide Route;
import 'package:frontend/convert.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/shared/datetime_selector.dart';
import 'package:frontend/ui/shared/text_address_selector.dart';

class CreateRideViewModel extends ChangeNotifier {
  CreateRideViewModel({
    required ActivityRepository activityRepository,
    required RideRepository rideRepository,
    required this.addressRepository,
  }) : _activityRepository = activityRepository,
       _rideRepository = rideRepository {
    _init();
  }

  List<Activity> get activities => _activities;
  String? get errorMessage => _errorMessage;
  List<Ride> get rides => _rides;
  bool get isLoading => _isLoading;
  bool get isFormValid =>
      _fromAddress != null &&
      _toAddress != null &&
      _departureTime != null &&
      _arrivalTime != null;
  bool get isCreatingRide => _isCreatingRide;

  Address? _fromAddress;
  Address? _toAddress;
  DateTime? _departureTime;
  DateTime? _arrivalTime;
  bool _isCreatingRide = false;

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
    fetchActivities();

    // Subscribe to activity updates
    _activitiesSubscription = _activityRepository.watch().listen(
      _onActivitiesUpdated,
    );
  }

  @override
  void dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }

  Future<void> selectActivity(Activity activity) async {
    var currentAddress = await addressRepository.fetchCurrent();

    fromAddressSelectorKey.currentState?.setAddress(currentAddress);
    toAddressSelectorKey.currentState?.setAddress(activity.address);

    departureTimeSelectorKey.currentState?.setDateTime(DateTime.now());
    arrivalTimeSelectorKey.currentState?.setDateTime(
      Convert.timeOfDayToDateTime(activity.startTime),
    );

    selectFromAddress(currentAddress);
    selectToAddress(activity.address);

    selectDepartureTime(DateTime.now());
    selectArrivalTime(Convert.timeOfDayToDateTime(activity.startTime));
  }

  Future<void> selectFromAddress(Address address) async {
    print("Selected from address: $address");
    _fromAddress = address;
    notifyListeners();
  }

  Future<void> selectToAddress(Address address) async {
    print("Selected to address: $address");
    _toAddress = address;
    notifyListeners();
  }

  Future<void> selectDepartureTime(DateTime? time) async {
    print("Selected departure time: $time");
    _departureTime = time;
    notifyListeners();
  }

  Future<void> selectArrivalTime(DateTime? time) async {
    print("Selected arrival time: $time");
    _arrivalTime = time;
    notifyListeners();
  }

  Future<void> fetchActivities() async {
    try {
      _activities = await _activityRepository.fetch();
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> createRide() async {
    if (_fromAddress == null || _toAddress == null || _departureTime == null) {
      _errorMessage = "Please fill in all fields.";
      notifyListeners();
      return false;
    }

    _isCreatingRide = true;
    notifyListeners();

    try {
      final ride = Ride.fake();
      await _rideRepository.create(ride);
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _errorMessage = "Failed to create ride: $e";
      return false;
    } finally {
      _isCreatingRide = false;
      notifyListeners();
    }
  }
}
