import 'dart:async';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class ImplRideRepository implements RideRepository {
  // --- Hardcoded rides ---
  final List<Ride> _rides = [
    Ride(
      id: 1,
      driver: Driver(
        id: 1,
        firstName: 'Alice',
        lastName: 'Smith',
        vehicle: Vehicle(id: 1, description: 'Red Sedan', capacity: 4),
        points: 100,
      ),
      passengers: [
        Passenger(firstName: 'Bob', lastName: 'Brown', points: 60, id: 0),
      ],
      route: Route.routes[0],
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2)),
      estimatedDuration: const Duration(hours: 1),
      totalSeats: 4,
    ),
    Ride(
      id: 2,
      driver: Driver(
        id: 2,
        firstName: 'John',
        lastName: 'Pork',
        vehicle: Vehicle(id: 1, description: 'Dababy car', capacity: 10),
        points: 40,
      ),
      passengers: [
        Passenger(firstName: 'Tim', lastName: 'Cheese', points: 60, id: 0),
        Passenger(firstName: 'Yo', lastName: 'Gurt', points: 90, id: 0),
      ],
      route: Route.routes[1],
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 3)),
      estimatedDuration: const Duration(hours: 4),
      totalSeats: 10, // ??? TODO - liability
    ),
  ];

  // --- Hardcoded ride history ---
  final List<Ride> _rideHistory = [
    Ride(
      id: 3,
      driver: Driver(
        id: 3,
        firstName: 'Crocodillo',
        lastName: 'Bombardiro',
        vehicle: Vehicle(id: 1, description: 'Flying Aligator', capacity: 100),
        points: 30,
      ),
      passengers: [
        Passenger(firstName: 'Tung', lastName: 'Tung', points: 70, id: 0),
      ],
      route: Route.routes[2],
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
  Future<List<User>> fetchPotentialPassengers(Ride ride) async {
    await Future.delayed(const Duration(seconds: 1));
    // Return some random passengers (hardcoded for demo)
    return [
      Passenger(firstName: 'Charlie', lastName: 'Delta', points: 50, id: 2),
      Passenger(firstName: 'Echo', lastName: 'Foxtrot', points: 80, id: 3),
      Passenger(firstName: 'Grace', lastName: 'Hopper', points: 95, id: 4),
    ];
  }

  @override
  Stream<List<User>> watchPotentialPassengers(Ride ride) async* {
    // Simulate a stream with a single user
    await Future.delayed(const Duration(milliseconds: 200));
    yield await fetchPotentialPassengers(ride);
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

  int idCounter = 0;
  int get nextId => idCounter++;

  @override
  Future<void> create(Ride ride) async {
    Ride newRide = Ride(
      id: nextId, // Simple ID generation
      driver: ride.driver,
      passengers: ride.passengers,
      route: ride.route,
      departureTime: ride.departureTime,
      estimatedArrivalTime: ride.estimatedArrivalTime,
      estimatedDuration: ride.estimatedDuration,
      totalSeats: ride.totalSeats,
    );
    _rides.add(newRide);
    _ridesController.add(List.unmodifiable(_rides));
    _rideHistory.add(newRide);
    _historyController.add(List.unmodifiable(_rideHistory));
    final driverId = newRide.driver.id;
    _createdRidesByDriver.putIfAbsent(driverId, () => []);
    _createdRidesByDriver[driverId]!.add(newRide);

    // Set the current newRide to the newly created newRide
    _currentRide = newRide;
    _currentRideController.add(newRide);
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

  @override
  Future<PickupRequest> offer(Ride ride, User potentialPassenger) async {
    // Simulate offering a ride to a potential passenger
    final passenger = Passenger(
      firstName: potentialPassenger.firstName,
      lastName: potentialPassenger.lastName,
      points: potentialPassenger.points,
      id: nextId, // Generate a new ID for the passenger
    );

    // Add the passenger to the ride
    ride.passengers.add(passenger);

    // Notify listeners about the updated ride
    _ridesController.add(List.unmodifiable(_rides));

    // Create a pickup request
    return PickupRequest.fake();
  }

  @override
  Future<List<Ride>> fetchCreatedRides() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Return all rides created by the driver
    return _createdRidesByDriver.values.expand((rides) => rides).toList();
  }

  @override
  Stream<List<Ride>> watchCreatedRides() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      _ridesController.add(List.unmodifiable(_rides));
      yield List.unmodifiable(_rides);
    }
  }
}
