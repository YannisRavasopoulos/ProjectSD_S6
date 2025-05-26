import 'dart:async';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:latlong2/latlong.dart';

class ImplRoute implements Route {
  @override
  final Location start;
  @override
  final Location end;
  @override
  final int id;

  ImplRoute({required this.id, required this.start, required this.end});
}

class ImplRide implements Ride {
  @override
  final int id;
  @override
  final Driver driver;
  @override
  final List<Passenger> passengers;
  @override
  final Route route;
  @override
  final DateTime departureTime;
  @override
  final DateTime estimatedArrivalTime;
  @override
  final Duration estimatedDuration;
  @override
  final int availableSeats;
  @override
  final int totalSeats;

  ImplRide({
    required this.id,
    required this.driver,
    required this.passengers,
    required this.route,
    required this.departureTime,
    required this.estimatedArrivalTime,
    required this.estimatedDuration,
    required this.availableSeats,
    required this.totalSeats,
  });
}

class ImplRideRepository implements RideRepository {
  final List<Ride> _rides = [];
  final StreamController<List<Ride>> _rideController =
      StreamController.broadcast();

  User? currentUser;

  // Ενημερώνει το stream με την τρέχουσα λίστα rides
  void _notifyStream() {
    _rideController.add(List.unmodifiable(_rides));
  }

  bool _matches(Ride ride, RideRequest request) {
    final distance = Distance();

    final originDistance = distance(
      request.origin.coordinates,
      ride.route.start.coordinates,
    );
    final destinationDistance = distance(
      request.destination.coordinates,
      ride.route.end.coordinates,
    );
    final depDiff = ride.departureTime.difference(request.departureTime).abs();
    final arrDiff =
        ride.estimatedArrivalTime.difference(request.arrivalTime).abs();

    return originDistance <= request.originRadius.radius &&
        destinationDistance <= request.destinationRadius.radius &&
        depDiff <= request.departureWindow &&
        arrDiff <= request.arrivalWindow &&
        ride.availableSeats > 0;
  }

  @override
  Future<List<Ride>> fetchMatchingRides(RideRequest request) async {
    return _rides.where((ride) => _matches(ride, request)).toList();
  }

  @override
  Stream<List<Ride>> watchMatchingRides(RideRequest request) {
    return _rideController.stream.map(
      (rides) => rides.where((ride) => _matches(ride, request)).toList(),
    );
  }

  @override
  Future<User> fetchPotentialPassengers(Ride ride) async {
    return Future.value(
      ride.passengers.cast<User>().firstWhere(
        (user) => user.id == currentUser?.id,
        orElse: () => throw Exception('No potential passengers found'),
      ),
    );
  }

  @override
  Stream<List<User>> watchPotentialPassengers(Ride ride) {
    return _rideController.stream.map((rides) {
      final found = rides.firstWhere((r) => r == ride, orElse: () => ride);
      return found.passengers.cast<User>();
    });
  }

  @override
  Future<List<Ride>> fetchHistory() async {
    return _rides;
  }

  @override
  Stream<List<Ride>> watchHistory() {
    return _rideController.stream.map((rides) => List.unmodifiable(rides));
  }

  @override
  Future<void> clearHistory() async {
    final now = DateTime.now();
    _rides.removeWhere((ride) => ride.estimatedArrivalTime.isBefore(now));
    _notifyStream();
  }

  @override
  Future<Ride> fetchCurrent() async {
    final now = DateTime.now();
    return _rides.firstWhere(
      (ride) =>
          ride.departureTime.isBefore(now) &&
          ride.estimatedArrivalTime.isAfter(now),
      orElse: () => throw Exception('No current ride found'),
    );
  }

  @override
  Stream<Ride> watchCurrent() {
    return _rideController.stream.map((rides) {
      final now = DateTime.now();
      return rides.firstWhere(
        (ride) =>
            ride.departureTime.isBefore(now) &&
            ride.estimatedArrivalTime.isAfter(now),
        orElse: () => throw Exception('No current ride found'),
      );
    });
  }

  @override
  Future<void> create(Ride ride) async {
    _rides.add(ride);
    _notifyStream();
  }

  @override
  Future<void> update(Ride ride) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides[index] = ride;
      _notifyStream();
    } else {
      throw Exception('Ride not found');
    }
  }

  @override
  Future<void> cancel(Ride ride) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides.removeAt(index);
      _notifyStream();
    } else {
      throw Exception('Ride not found');
    }
  }

  @override
  Future<void> join(Ride ride) async {
    if (currentUser == null) throw Exception('No current user set');
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      final passengers = _rides[index].passengers;
      if (!passengers.contains(currentUser) &&
          _rides[index].availableSeats > 0) {
        passengers.add(currentUser as dynamic);
        _notifyStream();
      }
    } else {
      throw Exception('Ride not found');
    }
  }

  @override
  Future<void> leave(Ride ride) async {
    if (currentUser == null) throw Exception('No current user set');
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      final passengers = _rides[index].passengers;
      passengers.remove(currentUser);
      _notifyStream();
    } else {
      throw Exception('Ride not found');
    }
  }

  void dispose() {
    _rideController.close();
  }
}
