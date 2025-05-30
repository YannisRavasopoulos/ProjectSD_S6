import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';

import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/vehicle.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('PickupRepository', () {
    late ImplPickupRepository pickupRepository;
    late PickupRequest pickupRequest;
    late Pickup pickup;
    late Ride ride;
    late Passenger passenger;
    late Driver driver;
    late Address address;

    setUp(() {
      pickupRepository = ImplPickupRepository();
      address = Address(
        id: 1,
        coordinates: LatLng(37.9838, 23.7275),
        city: 'Athens',
        street: 'Main St',
        number: 1,
        postalCode: '12345',
      );
      driver = Driver(
        id: 1,
        firstName: 'DriverFirst',
        lastName: 'DriverLast',
        points: 100,
        vehicle: Vehicle(
          id: 1,
          description: 'Toyota Corolla Blue XYZ123',
          capacity: 4,
        ),
      );
      passenger = Passenger(
        id: 2,
        firstName: 'PassengerFirst',
        lastName: 'PassengerLast',
        points: 50,
      );
      ride = Ride(
        driver: driver,
        passengers: [],
        route: Route(id: 1, start: address, end: address),
        departureTime: DateTime.now().add(const Duration(hours: 1)),
        estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2)),
        estimatedDuration: const Duration(hours: 1),
        totalSeats: 4,
      );
      pickupRequest = PickupRequest(
        id: 1,
        ride: ride,
        passenger: passenger,
        address: address,
        time: DateTime.now(),
      );
      pickup = Pickup(
        id: 1,
        ride: ride,
        passenger: passenger,
        address: address,
        time: DateTime.now(),
      );
    });

    test('requestPickup adds a pickup request', () async {
      final result = await pickupRepository.requestPickup(pickupRequest);
      expect(result.ride, pickupRequest.ride);
      final requests = await pickupRepository.fetchPickupRequests();
      expect(requests.any((r) => r.ride == pickupRequest.ride), isTrue);
    });

    test('fetchPickupRequests returns pickup requests', () async {
      await pickupRepository.requestPickup(pickupRequest);
      final requests = await pickupRepository.fetchPickupRequests();
      expect(requests, isA<List<PickupRequest>>());
      expect(requests.isNotEmpty, isTrue);
    });

    test('watchPickupRequests emits pickup requests', () async {
      final stream = pickupRepository.watchPickupRequests();
      await pickupRepository.requestPickup(pickupRequest);
      expectLater(
        stream,
        emits(
          predicate<List<PickupRequest>>(
            (requests) => requests.any((r) => r.ride == pickupRequest.ride),
          ),
        ),
      );
    });

    test('acceptPickup moves pickup to pending', () async {
      await pickupRepository.acceptPickup(pickup);
      final pending = await pickupRepository.fetchPending();
      expect(pending.any((p) => p.ride == pickup.ride), isTrue);
    });

    test('rejectPickup removes pickup from pending', () async {
      await pickupRepository.acceptPickup(pickup);
      await pickupRepository.rejectPickup(pickup);
      final pending = await pickupRepository.fetchPending();
      expect(pending.any((p) => p.ride == pickup.ride), isFalse);
    });

    test('acceptPickupRequest moves request to pending', () async {
      await pickupRepository.requestPickup(pickupRequest);
      await pickupRepository.acceptPickupRequest(pickupRequest, pickup);
      final pending = await pickupRepository.fetchPending();
      expect(pending.any((p) => p.ride == pickup.ride), isTrue);
      final requests = await pickupRepository.fetchPickupRequests();
      expect(requests.any((r) => r.ride == pickupRequest.ride), isFalse);
    });

    test('rejectPickupRequest removes request', () async {
      await pickupRepository.requestPickup(pickupRequest);
      await pickupRepository.rejectPickupRequest(pickupRequest);
      final requests = await pickupRepository.fetchPickupRequests();
      expect(requests.any((r) => r.ride == pickupRequest.ride), isFalse);
    });

    test('fetchPending returns pending pickups', () async {
      await pickupRepository.acceptPickup(pickup);
      final pending = await pickupRepository.fetchPending();
      expect(pending, isA<List<Pickup>>());
      expect(pending.any((p) => p.ride == pickup.ride), isTrue);
    });

    // test('watchPending emits pending pickups', () async {
    //   final stream = pickupRepository.watchPending();
    //   await pickupRepository.acceptPickup(pickup);
    //   expectLater(
    //     stream,
    //     emits(
    //       predicate<List<Pickup>>(
    //         (pending) => pending.any((p) => p.ride == pickup.ride),
    //       ),
    //     ),
    //   );
    // });

    test('fetchCompleted returns completed pickups', () async {
      await pickupRepository.acceptPickup(pickup);
      await pickupRepository.completePickup(pickup);
      final completed = await pickupRepository.fetchCompleted();
      expect(completed, isA<List<Pickup>>());
      expect(completed.any((p) => p.ride == pickup.ride), isTrue);
    });

    // test('watchCompleted emits completed pickups', () async {
    //   await pickupRepository.acceptPickup(pickup);
    //   await pickupRepository.completePickup(pickup);
    //   final stream = pickupRepository.watchCompleted();
    //   expectLater(
    //     stream,
    //     emits(
    //       predicate<List<Pickup>>(
    //         (completed) => completed.any((p) => p.ride == pickup.ride),
    //       ),
    //     ),
    //   );
    // });

    test('cancelPickup removes pickup from pending', () async {
      await pickupRepository.acceptPickup(pickup);
      await pickupRepository.cancelPickup(pickup);
      final pending = await pickupRepository.fetchPending();
      expect(pending.any((p) => p.ride == pickup.ride), isFalse);
    });

    test('completePickup moves pickup from pending to completed', () async {
      await pickupRepository.acceptPickup(pickup);
      await pickupRepository.completePickup(pickup);
      final pending = await pickupRepository.fetchPending();
      final completed = await pickupRepository.fetchCompleted();
      expect(pending.any((p) => p.ride == pickup.ride), isFalse);
      expect(completed.any((p) => p.ride == pickup.ride), isTrue);
    });
  });
}
