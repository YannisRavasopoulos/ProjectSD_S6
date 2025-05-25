import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';

abstract interface class PickupRepository {
  // ==== Passenger methods ====

  /// Return a pickup if accepted, otherwise throw exception.
  Future<Pickup> requestPickup(PickupRequest request);

  /// Fetch pickup requests for this ride.
  Future<List<PickupRequest>> fetchPickupRequests();

  /// Watch pickup requests for this ride.
  Stream<List<PickupRequest>> watchPickupRequests();

  /// Accept pickup (Passenger).
  Future<void> acceptPickup(Pickup pickup);

  /// Reject pickup (Passenger).
  Future<void> rejectPickup(Pickup pickup);

  // ==== Driver methods ====

  /// Accept a pickup request.
  Future<void> acceptPickupRequest(PickupRequest request, Pickup pickup);

  /// Reject a pickup request. Kicks the passenger from the ride.
  Future<void> rejectPickupRequest(PickupRequest request);

  /// Fetch pending pickups for this ride.
  Future<List<Pickup>> fetchPending();

  /// Watch pending pickups for this ride.
  Stream<List<Pickup>> watchPending();

  /// Watch completed pickups for this ride.
  Stream<List<Pickup>> watchCompleted();

  // ==== General methods ====

  /// Fetch completed pickups for this ride.
  Future<List<Pickup>> fetchCompleted();

  /// Cancel a pickup.
  Future<void> cancelPickup(Pickup pickup);

  /// Complete a pickup.
  Future<void> completePickup(Pickup pickup);
}
