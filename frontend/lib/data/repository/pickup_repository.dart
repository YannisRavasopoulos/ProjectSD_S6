import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';

abstract interface class PickupRepository {
  /// Return a pickup if accepted, otherwise throw exception.
  Future<Pickup> requestPickup(PickupRequest request);

  /// Fetch pending pickups for this ride.
  Future<List<Pickup>> fetchPending();

  /// Fetch completed pickups for this ride.
  Future<List<Pickup>> fetchCompleted();

  /// Watch pending pickups for this ride.
  Stream<List<Pickup>> watchPending();

  /// Watch completed pickups for this ride.
  Stream<List<Pickup>> watchCompleted();

  /// Fetch pickup requests for this ride.
  Future<List<PickupRequest>> fetchPickupRequests();

  /// Watch pickup requests for this ride.
  Stream<List<PickupRequest>> watchPickupRequests();

  /// Accept a pickup request.
  Future<void> acceptPickup(PickupRequest request);

  /// Reject a pickup request.
  Future<void> rejectPickup(PickupRequest request);

  /// Complete a pickup.
  Future<void> completePickup(Pickup pickup);
}
