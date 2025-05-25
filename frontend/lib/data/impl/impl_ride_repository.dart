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

class ImplRideRepository implements RideRepository {
  final List<Ride> _rides = [];
  final StreamController<List<Ride>> _rideController =
      StreamController.broadcast();

  User? currentUser; // current user for joining/leaving rides

  void notifyListeners() {
    _rideController.add(List.unmodifiable(_rides));
  }

  // Private method to check if a ride matches the request
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
    final now = DateTime.now();
    return _rides
        .where((ride) => ride.estimatedArrivalTime.isBefore(now))
        .toList();
  }

  @override
  Stream<List<Ride>> watchHistory() {
    return _rideController.stream.map((rides) {
      final now = DateTime.now();
      return rides
          .where((ride) => ride.estimatedArrivalTime.isBefore(now))
          .toList();
    });
  }

  @override
  Future<void> clearHistory() async {
    final now = DateTime.now();
    _rides.removeWhere((ride) => ride.estimatedArrivalTime.isBefore(now));
    notifyListeners();
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
    notifyListeners();
  }

  @override
  Future<void> update(Ride ride) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides[index] = ride;
      notifyListeners();
    } else {
      throw Exception('Ride not found');
    }
  }

  @override
  Future<void> cancel(Ride ride) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides.removeAt(index);
      notifyListeners();
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
        notifyListeners();
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
      notifyListeners();
    } else {
      throw Exception('Ride not found');
    }
  }

  void dispose() {
    _rideController.close();
  }
}
