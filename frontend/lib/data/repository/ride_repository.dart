import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/location.dart';

class RideRepository {
  List<Ride> _rides = [];

  Future<List<Ride>> fetchMatching(
    Location from,
    Location to,
    DateTime when,
    // TODO add more filters
  ) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    return _rides;
  }

  Stream<List<Ride>> watchMatching(
    Location from,
    Location to,
    DateTime when,
  ) async* {
    while (true) {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      yield await fetchMatching(from, to, when);
    }
  }

  Future<List<Ride>> fetchById(int id) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    return _rides.where((ride) => ride.id == id).toList();
  }

  Stream<List<Ride>> watchById(int id) async* {
    while (true) {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      yield await fetchById(id);
    }
  }

  Future<List<Ride>> fetch() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    return _rides;
  }

  Stream<List<Ride>> watch() async* {
    while (true) {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      yield _rides;
    }
  }

  // Create a ride
  Future<void> create(Ride ride) async {
    _rides.add(ride);
  }

  // Update a ride
  Future<void> update(Ride ride) async {
    final index = _rides.indexWhere((r) => r.id == ride.id);
    if (index != -1) {
      _rides[index] = ride;
    }
  }

  // Delete a ride
  Future<void> delete(int id) async {
    _rides.removeWhere((ride) => ride.id == id);
  }
}
