import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_passenger.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/route.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('RideRepository', () {
  
    late ImplRideRepository rideRepository;
    late Ride testRide;
    late RideRequest testRequest;
    late Driver testDriver;
    late Passenger testPassenger;
    late int initialRides;

    setUp(() {
      rideRepository = ImplRideRepository();
      initialRides = 2;
      testDriver = ImplDriver(
        id: 1,
        firstName: 'DriverFirst',
        lastName: 'DriverLast',
        points: 100,
        vehicle: ImplVehicle(
          id: 1,
          description: 'Toyota Corolla Blue XYZ123',
          capacity: 4,
        ),
      );
      testPassenger = ImplPassenger(
        id: 2,
        firstName: 'PassengerFirst',
        lastName: 'PassengerLast',
        points: 50,
      );
      testRide = Ride(
        driver: testDriver,
        passengers: [],
        route: Route(
          start: Address.fake(),
          end: Address.fake(),
        ),
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        estimatedArrivalTime: DateTime.now().add(const Duration(hours: 6)),
        estimatedDuration: const Duration(hours: 1),
        totalSeats: 4,
      );
      testRequest = RideRequest(
        origin: Address.fake(),
        destination: Address.fake(),
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        arrivalTime: DateTime.now().add(const Duration(hours: 6)),
        originRadius: const Distance(),
        destinationRadius: const Distance(),
        departureWindow: const Duration(minutes: 15),
        arrivalWindow: const Duration(minutes: 15),
      );
    });

    test('fetchAllRides returns all rides', () async {
      final rides = await rideRepository.fetchAllRides();
      expect(rides, isA<List<Ride>>());
      expect(rides.length, initialRides);
    });

    test('create adds a ride', () async {
      
      await rideRepository.create(testRide);
      final rides = await rideRepository.fetchAllRides();
      expect(rides.length, initialRides + 1);
      expect(rides[initialRides].driver.id ==testDriver.id, isTrue); //use ride id when ride repo is updated
    });

    test('fetchMatchingRides returns rides near origin', () async {
      await rideRepository.create(testRide);
      final rides = await rideRepository.fetchMatchingRides(testRequest);
      expect(rides, isA<List<Ride>>());
    });
  test('clearHistory clears the ride history', () async {
        await rideRepository.clearHistory();
        final history = await rideRepository.fetchHistory();
        expect(history, isEmpty);
      });
    test('watchMatchingRides emits matching rides', () async {
      await rideRepository.clearHistory();
      await rideRepository.create(testRide);
      final stream = rideRepository.watchMatchingRides(testRequest);
      expectLater(stream, emits(isA<List<Ride>>()));
    });

    test('fetchHistory returns ride history', () async {
      await rideRepository.create(testRide);
      final history = await rideRepository.fetchHistory();
      expect(history, isA<List<Ride>>());
      expect(history.isNotEmpty, isTrue);
      expect(history.last.driver.id, testDriver.id); //use ride id when ride repo is updated
    });

    test('watchHistory emits ride history', () async {
      final stream = rideRepository.watchHistory();
      expectLater(stream, emits(isA<List<Ride>>()));
    });

   

    test('fetchCurrent throws if no current ride', () async {
      expect(() async => await rideRepository.fetchCurrent(), throwsA(isA<Exception>()));
    });

    test('join sets current ride', () async {
      await rideRepository.create(testRide);
      await rideRepository.join(testRide);
      final current = await rideRepository.fetchCurrent();
      expect(current.driver.id, testDriver.id); //use ride id when ride repo is updated
    });

    test('leave clears current ride', () async {
      await rideRepository.create(testRide);
      await rideRepository.join(testRide);
      await rideRepository.leave(testRide);
      expect(() async => await rideRepository.fetchCurrent(), throwsA(isA<Exception>()));
    });

    test('update modifies a ride', () async {
   to be mor   await rideRepository.create(testRide); //does not have passengers yet
      final updatedRide = Ride(
        driver: testDriver,
        passengers: [testPassenger], //update to have passengers
        route: testRide.route,
        departureTime: testRide.departureTime,
        estimatedArrivalTime: testRide.estimatedArrivalTime,
        estimatedDuration: testRide.estimatedDuration,
        totalSeats: testRide.totalSeats,
      );
      await rideRepository.update(updatedRide);
      final rides = await rideRepository.fetchAllRides();
     expect(
          rides[initialRides + 1].passengers.any((p) => p.id == testPassenger.id),
  isTrue,
);
    });

    test('cancel removes a ride', () async {
      await rideRepository.create(testRide);
      await rideRepository.cancel(testRide);
      final rides = await rideRepository.fetchAllRides();
      expect(rides.any((r) => r.driver.id == testDriver.id), isFalse); //use ride id when ride repo is updated
    });
  });
}