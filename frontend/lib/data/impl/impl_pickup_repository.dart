import 'dart:async';
import 'dart:math';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/place.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:latlong2/latlong.dart';

class ImplPickupRepository implements PickupRepository {
  final List<PickupRequest> _pickupRequests =
      []; // Requests awaiting driver approval
  final List<Pickup> _pendingPickups =
      []; // Pickups accepted by driver, awaiting passenger acceptance/completion
  final List<Pickup> _completedPickups = []; // Completed pickups

  final StreamController<List<PickupRequest>> _requestsController =
      StreamController<List<PickupRequest>>.broadcast();
  final StreamController<List<Pickup>> _pendingController =
      StreamController<List<Pickup>>.broadcast();
  final StreamController<List<Pickup>> _completedController =
      StreamController<List<Pickup>>.broadcast();

  // ==== Passenger methods ====

  @override
  Future<Pickup> requestPickup(PickupRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    // Vazoume to request sta pending requests (awaiting driver approval)
    _pickupRequests.add(request);
    _requestsController.add(List.from(_pickupRequests));

    // Pick a random address from the list
    final random = Random();
    final nearbyAddress = places[random.nextInt(places.length)];

    // dummy returning pickup instance - testing purposes
    final pickup = Pickup(
      ride: request.ride,
      passenger: request.passenger,
      address: nearbyAddress.address,
      time: request.time,
    );

    return pickup;
  }

  @override
  Future<void> acceptPickup(Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Passenger accepts the pickup - this confirms they want to proceed
    // The pickup should already be in pending state (driver has accepted the request)
    if (!_pendingPickups.any((p) => p == pickup)) {
      _pendingPickups.add(pickup);
      _pendingController.add(List.from(_pendingPickups));
    }
  }

  @override
  Future<void> rejectPickup(Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Passenger rejects the pickup: TODO
    _pendingPickups.removeWhere((p) => p == pickup);
    _pendingController.add(List.from(_pendingPickups));
  }

  // ==== Driver methods ====

  @override
  Future<void> acceptPickupRequest(PickupRequest request, Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Driver accepts the request - apo requests se pending pickups
    _pickupRequests.removeWhere((r) => r.ride == request.ride);
    _pendingPickups.add(pickup);

    _requestsController.add(List.from(_pickupRequests));
    _pendingController.add(List.from(_pendingPickups));
  }

  @override
  Future<void> rejectPickupRequest(PickupRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Driver rejects the request
    _pickupRequests.removeWhere((r) => r.ride == request.ride);
    _requestsController.add(List.from(_pickupRequests));
  }

  @override
  Future<List<Pickup>> fetchPending() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pendingPickups);
  }

  @override
  Stream<List<Pickup>> watchPending() {
    return _pendingController.stream;
  }

  @override
  Future<List<PickupRequest>> fetchPickupRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pickupRequests);
  }

  @override
  Stream<List<PickupRequest>> watchPickupRequests() {
    return _requestsController.stream;
  }

  // ==== General methods ====

  @override
  Future<List<Pickup>> fetchCompleted() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_completedPickups);
  }

  @override
  Stream<List<Pickup>> watchCompleted() {
    return _completedController.stream;
  }

  @override
  Future<void> cancelPickup(Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Afairw to pickup (at any stage)
    _pendingPickups.removeWhere((p) => p == pickup);
    _pendingController.add(List.from(_pendingPickups));
  }

  @override
  Future<void> completePickup(Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Move pickup apo pending se completed
    _pendingPickups.removeWhere((p) => p == pickup);
    _completedPickups.add(pickup);

    _pendingController.add(List.from(_pendingPickups));
    _completedController.add(List.from(_completedPickups));
  }

  void dispose() {
    _requestsController.close();
    _pendingController.close();
    _completedController.close();
  }

  // Testing method for adding pickup requests manually
  void addPickupRequest(PickupRequest request) {
    _pickupRequests.add(request);
    _requestsController.add(List.from(_pickupRequests));
  }
}
