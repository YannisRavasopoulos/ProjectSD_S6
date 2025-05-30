import 'dart:async';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_passenger.dart';
import 'package:latlong2/latlong.dart';

class ImplRideRepository implements RideRepository {
  // --- Hardcoded rides ---
  final List<Ride> _rides = [
    Ride(
      driver: ImplDriver(
        id: 1,
        firstName: 'Alice',
        lastName: 'Smith',
        vehicle: ImplVehicle(id: 1, description: 'Red Sedan', capacity: 4),
        points: 100,
      ),
      passengers: [
        ImplPassenger(id: 94, firstName: 'Bob', lastName: 'Brown', points: 60),
      ],
      route: Route(start: Address.fake(), end: Address.fake()), // TODO: FIX
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2)),
      estimatedDuration: const Duration(hours: 1),
      totalSeats: 4,
    ),
    Ride(
      driver: ImplDriver(
        id: 2,
        firstName: 'John',
        lastName: 'Pork',
        vehicle: ImplVehicle(id: 1, description: 'Dababy car', capacity: 10),
        points: 40,
      ),
      passengers: [
        ImplPassenger(id: 10, firstName: 'Tim', lastName: 'Cheese', points: 60),
        ImplPassenger(id: 11, firstName: 'Yo', lastName: 'Gurt', points: 90),
      ],
      route: Route(start: Address.fake(), end: Address.fake()), // TODO: FIX
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 3)),
      estimatedDuration: const Duration(hours: 4),
      totalSeats: 10, // ??? TODO - liability
    ),
  ];

  // --- Hardcoded ride history ---
  final List<Ride> _rideHistory = [
    Ride(
      driver: ImplDriver(
        id: 1,
        firstName: 'Crocodillo',
        lastName: 'Bombardiro',
        vehicle: ImplVehicle(
          id: 1,
          description: 'Flying Aligator',
          capacity: 100,
        ),
        points: 30,
      ),
      passengers: [
        ImplPassenger(id: 33, firstName: 'Tung', lastName: 'Tung', points: 70),
      ],
      route: Route(start: Address.fake(), end: Address.fake()), // TODO: Test
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2)),
      estimatedDuration: const Duration(hours: 1),
      totalSeats: 100,
    ),
  ];

  Ride? _currentRide;

  final StreamController<List<Ride>> _ridesController =
      StreamController<List<Ride>>.broadcast();
  final StreamController<List<Ride>> _historyController =
      StreamController<List<Ride>>.broadcast();
  final StreamController<Ride> _currentRideController =
      StreamController<Ride>.broadcast();

  final Map<int, List<Ride>> _createdRidesByDriver = {};

  int _distance(LatLng a, LatLng b) {
    var d = Distance();
    return d
        .as(
          LengthUnit.Meter,
          LatLng(a.latitude, a.longitude),
          LatLng(b.latitude, b.longitude),
        )
        .round();
  }

  @override
  Future<List<Ride>> fetchMatchingRides(RideRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _rides.where((ride) {
      // Match by proximity to origin
      final originMatch =
          _distance(ride.route.start.coordinates, request.origin.coordinates) <=
          10000; // within 10 km TODO hardcoded

      return originMatch;
    }).toList();
  }

  @override
  Future<List<Ride>> fetchAllRides() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_rides);
  }

  @override
  Stream<List<Ride>> watchMatchingRides(RideRequest request) async* {
    yield await fetchMatchingRides(request);
    yield* _ridesController.stream;
  }

  @override
  Future<User> fetchPotentialPassengers(Ride ride) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (ride.passengers.isNotEmpty) {
      return ride.passengers.first;
    } else {
      throw Exception('No passengers found for this ride');
    }
  }

  @override
  Stream<List<User>> watchPotentialPassengers(Ride ride) async* {
    // Simulate a stream with a single user
    await Future.delayed(const Duration(milliseconds: 200));
    yield ride.passengers;
  }

  @override
  Future<List<Ride>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_rideHistory);
  }

  @override
  Stream<List<Ride>> watchHistory() async* {
    yield await fetchHistory();
    yield* _historyController.stream;
  }

  @override
  Future<void> clearHistory() async {
    _rideHistory.clear();
    _historyController.add(List.unmodifiable(_rideHistory));
  }

  @override
  Future<Ride> fetchCurrent() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentRide != null) {
      return _currentRide!;
    }
    throw Exception('No current ride');
  }

  @override
  Stream<Ride> watchCurrent() async* {
    if (_currentRide != null) {
      yield _currentRide!;
    }
    yield* _currentRideController.stream;
  }

  @override
  Future<void> create(Ride ride) async {
    _rides.add(ride);
    _ridesController.add(List.unmodifiable(_rides));
    _rideHistory.add(ride);
    _historyController.add(List.unmodifiable(_rideHistory));
    final driverId = ride.driver.id;
    _createdRidesByDriver.putIfAbsent(driverId, () => []);
    _createdRidesByDriver[driverId]!.add(ride);

    // Set the current ride to the newly created ride
    _currentRide = ride;
    _currentRideController.add(ride);
  }

  List<Ride> getCreatedRidesForDriver(int driverId) {
    return List.unmodifiable(_createdRidesByDriver[driverId] ?? []);
  }

  @override
  Future<void> update(Ride ride, int id) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides[index] = ride;
      _ridesController.add(List.unmodifiable(_rides));
    }
    final histIndex = _rideHistory.indexWhere((r) => r.id == ride.id);
    if (histIndex != -1) {
      _rideHistory[histIndex] = ride;
      _historyController.add(List.unmodifiable(_rideHistory));
    }
  }

  @override
  Future<void> cancel(Ride ride) async {
    _rides.removeWhere((r) => r == ride);
    _ridesController.add(List.unmodifiable(_rides));
    _rideHistory.removeWhere((r) => r == ride);
    _historyController.add(List.unmodifiable(_rideHistory));
  }

  @override
  Future<void> join(Ride ride) async {
    _currentRide = ride;
    _currentRideController.add(ride);
  }

  @override
  Future<void> leave(Ride ride) async {
    if (_currentRide == ride) {
      _currentRide = null;
      // Optionally notify listeners
    }
  }
}
