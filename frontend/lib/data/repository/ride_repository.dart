import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/user.dart';

abstract interface class RideRepository {
  /// Fetches rides based on the given parameters.
  Future<List<Ride>> fetchMatchingRides(RideRequest request);

  /// Watches for changes in matching rides.
  Stream<List<Ride>> watchMatchingRides(RideRequest request);

  /// Returns potential passengers.
  Future<List<User>> fetchPotentialPassengers(Ride ride);

  /// Watches potential passengers.
  Stream<List<User>> watchPotentialPassengers(Ride ride);

  /// Fetch past rides.
  Future<List<Ride>> fetchHistory();

  /// Watches for changes in past rides.
  Stream<List<Ride>> watchHistory();

  /// Clear ride history.
  Future<void> clearHistory();

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
