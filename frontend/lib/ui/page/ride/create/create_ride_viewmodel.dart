import 'dart:async';
import 'package:flutter/material.dart' hide Route;
import 'package:frontend/convert.dart';
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/route.dart';
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
      final ride = Ride(
        driver: ImplDriver(
          id: 0,
          firstName: "Test",
          lastName: "Driver",
          vehicle: ImplVehicle(id: 1, description: "Test Car", capacity: 4),
          points: 100,
        ),
        passengers: [],
        departureTime: _departureTime!,
        estimatedArrivalTime:
            _arrivalTime ?? _departureTime!.add(Duration(hours: 1)),
        estimatedDuration: Duration(hours: 1),
        totalSeats: 4, // Default capacity
        route: Route(start: _fromAddress!, end: _toAddress!),
      );

      await _rideRepository.create(ride);
      return true;
    } catch (e) {
      _errorMessage = "Failed to create ride: $e";
      return false;
    } finally {
      _isCreatingRide = false;
      notifyListeners();
    }
  }

  // final RideRepository rideRepository;
  // final Ride? initialRide;
  // StreamSubscription<List<Ride>>? _ridesSubscription;

  // TextEditingController fromLocationController = TextEditingController();
  // TextEditingController toLocationController = TextEditingController();

  // List<Ride> _rides = [];
  // List<Ride> get rides => _rides;

  // TimeOfDay? departureTime;
  // int seats = 1;
  // int capacity = 4;
  // Ride? createdRide;
  // Ride? updatedRide;
  // int? id;
  // Address? startLocation;
  // Address? endLocation;
  // String firstName = "John";
  // String lastName = "Doe";
  // int points = 300; // Default points for the driver
  // Driver? driver;

  // bool isLoading = false;
  // String? errorMessage;
  // String? successMessage;

  // CreateRideViewModel({required this.rideRepository}) {
  //   // if (initialRide != null) {
  //   //   id = initialRide!.id;
  //   //   from = initialRide!.route.start.name;
  //   //   to = initialRide!.route.end.name;
  //   //   departureTime = TimeOfDay(
  //   //     hour: initialRide!.departureTime.hour,
  //   //     minute: initialRide!.departureTime.minute,
  //   //   );
  //   //   seats = initialRide!.totalSeats - initialRide!.availableSeats;
  //   //   capacity = initialRide!.totalSeats;
  //   //   driver = initialRide!.driver;
  //   // }
  //   _init();
  // }

  // void _init() {
  //   _ridesSubscription = rideRepository.watchHistory().listen(
  //     (rides) {
  //       _rides = rides;
  //       notifyListeners();
  //     },
  //     onError: (error) {
  //       errorMessage = error.toString();
  //       notifyListeners();
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _ridesSubscription?.cancel();
  //   super.dispose();
  // }

  // void setFrom(Address start) {
  //   startLocation = start;
  //   notifyListeners();
  // }

  // void setTo(Address end) {
  //   endLocation = end;
  //   notifyListeners();
  // }

  // void setDepartureTime(TimeOfDay value) {
  //   departureTime = value;
  //   notifyListeners();
  // }

  // void setSeats(int value) {
  //   seats = value;
  //   notifyListeners();
  // }

  // void setCapacity(int value) {
  //   capacity = value;
  //   notifyListeners();
  // }

  // void createInitialRide(Ride initialRide) {
  //   startLocation = initialRide.route.start;
  //   endLocation = initialRide.route.end;
  //   departureTime = TimeOfDay(
  //     hour: initialRide.departureTime.hour,
  //     minute: initialRide.departureTime.minute,
  //   );
  //   seats = initialRide.totalSeats - initialRide.availableSeats;
  //   capacity = initialRide.totalSeats;
  //   driver = initialRide.driver;
  //   notifyListeners();
  // }

  // Future<Ride?> saveRide() async {
  //   if (startLocation == null ||
  //       endLocation == null ||
  //       departureTime == null ||
  //       seats < 1) {
  //     errorMessage = "Please fill in all fields.";
  //     notifyListeners();
  //     return null;
  //   }
  //   isLoading = true;
  //   errorMessage = null;
  //   successMessage = null;
  //   notifyListeners();

  //   try {
  //     final now = DateTime.now();
  //     final dt = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       departureTime!.hour,
  //       departureTime!.minute,
  //     );

  //     // final startLocation = ImplLocation(
  //     //   id: DateTime.now().millisecondsSinceEpoch,
  //     //   coordinates: LatLng(37.0, 23.0),
  //     //   name: from!,
  //     // );
  //     // final endLocation = ImplLocation(
  //     //   id: DateTime.now().millisecondsSinceEpoch + 1,
  //     //   coordinates: LatLng(37.5, 23.5),
  //     //   name: to!,
  //     // );

  //     final repo = rideRepository as ImplRideRepository;

  //     // Await the driver fetch
  //     Driver driver;
  //     try {
  //       final currentRide = await repo.fetchCurrent();
  //       driver = currentRide.driver;
  //     } catch (_) {
  //       // Fallback: create a test driver if none exists
  //       driver = ImplDriver(
  //         id: 999,
  //         firstName: "Test",
  //         lastName: "Driver",
  //         vehicle: ImplVehicle(
  //           id: 1,
  //           description: "Test Car",
  //           capacity: capacity,
  //         ),
  //         points: 100,
  //       );
  //     }

  //     final route = Route(start: startLocation!, end: endLocation!);

  //     final ride = Ride(
  //       driver: driver,
  //       passengers: [],
  //       departureTime: dt,
  //       estimatedArrivalTime: dt.add(const Duration(hours: 1)),
  //       estimatedDuration: const Duration(hours: 1),
  //       totalSeats: seats, // <-- use the selected seats here!
  //       route: route,
  //     );

  //     await rideRepository.create(ride);
  //     successMessage = "Ride created successfully!";
  //     createdRide = ride;

  //     return ride;
  //   } catch (e) {
  //     errorMessage = "Failed to save ride: $e";
  //     return null;
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // void clearMessages() {
  //   errorMessage = null;
  //   successMessage = null;
  //   notifyListeners();
  // }
}
