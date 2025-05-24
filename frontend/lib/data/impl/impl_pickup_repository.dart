import 'dart:async';
import 'dart:math';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/pickup_repository.dart';

class ImplPickup extends Pickup {
  @override
  final int id;
  @override
  final Passenger passenger;
  @override
  final Location location;
  @override
  final DateTime time;
  @override
  final DateTime createdAt;

  ImplPickup({
    required this.id,
    required this.passenger,
    required this.location,
    required this.time,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class ImplPickupRepository implements PickupRepository {
  final List<Pickup> _pendingPickups = [];
  final List<Pickup> _completedPickups = [];
  final List<PickupRequest> _pickupRequests = [];

  final StreamController<List<Pickup>> _pendingController =
      StreamController<List<Pickup>>.broadcast();
  final StreamController<List<Pickup>> _completedController =
      StreamController<List<Pickup>>.broadcast();
  final StreamController<List<PickupRequest>> _requestsController =
      StreamController<List<PickupRequest>>.broadcast();

  @override
  Future<Pickup> requestPickup(PickupRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final pickup = ImplPickup(
      id: Random().nextInt(10000),
      passenger: request.passenger,
      location: request.location,
      time: request.time,
    );

    _pendingPickups.add(pickup);
    _pendingController.add(List.from(_pendingPickups));

    return pickup;
  }

  @override
  Future<List<Pickup>> fetchPending() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pendingPickups);
  }

  @override
  Future<List<Pickup>> fetchCompleted() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_completedPickups);
  }

  @override
  Stream<List<Pickup>> watchPending() {
    return _pendingController.stream;
  }

  @override
  Stream<List<Pickup>> watchCompleted() {
    return _completedController.stream;
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

  @override
  Future<void> acceptPickup(PickupRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _pickupRequests.removeWhere((r) => r.id == request.id);

    final pickup = ImplPickup(
      id: Random().nextInt(10000),
      passenger: request.passenger,
      location: request.location,
      time: request.time,
    );

    _pendingPickups.add(pickup);
    _requestsController.add(List.from(_pickupRequests));
    _pendingController.add(List.from(_pendingPickups));
  }

  @override
  Future<void> rejectPickup(PickupRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _pickupRequests.removeWhere((r) => r.id == request.id);

    _requestsController.add(List.from(_pickupRequests));
  }

  @override
  Future<void> completePickup(Pickup pickup) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _pendingPickups.removeWhere((p) => p.id == pickup.id);
    _completedPickups.add(pickup);

    _pendingController.add(List.from(_pendingPickups));
    _completedController.add(List.from(_completedPickups));
  }

  void dispose() {
    _pendingController.close();
    _completedController.close();
    _requestsController.close();
  }

  // Testing Method - gia manual access
  // void addPickupRequest(PickupRequest request) {
  //   _pickupRequests.add(request);
  //   _requestsController.add(List.from(_pickupRequests));
  // }
}
