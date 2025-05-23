import 'package:frontend/data/interface/user.dart';
import 'package:frontend/data/model/ride.dart';

abstract interface class RideRepository {
  /// Fetches rides based on the given parameters.
  Future<List<Ride>> fetchMatching(RideRequest request);

  /// Watches for changes in matching rides.
  Stream<List<Ride>> watchMatching(RideRequest request);

  /// Fetch current ride.
  Future<Ride> fetchCurrent();

  /// Watches for changes in the current ride.
  Stream<Ride> watchCurrent();

  /// Create a new ride.
  Future<void> create(Ride ride);

  /// Update a ride.
  Future<void> update(Ride ride);

  /// Cancel a ride.
  Future<void> cancel(Ride ride);

  /// Join a ride.
  Future<void> join(Ride ride);

  /// Leave a ride.
  Future<void> leave(Ride ride);
}
