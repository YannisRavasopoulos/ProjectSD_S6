import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/vehicle.dart';
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

      // Define a fixed location for both ride and request
      final fixedLatLng = LatLng(37.9838, 23.7275); 
      final farLatLng = LatLng(38.0, 23.8); 

      final testAddress = Address(
        id: 1,
        coordinates: fixedLatLng,
        city: 'Athens',
        street: 'Main St',
        number: 1,
        postalCode: '12345',
      );

      final farAddress = Address(
        id: 1,
        coordinates: farLatLng,
        city: 'FarTown',
        street: 'Far St',
        number: 2,
        postalCode: '54321',
      );

      testDriver = Driver(
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
      testPassenger = Passenger(
        id: 2,
        firstName: 'PassengerFirst',
        lastName: 'PassengerLast',
        points: 50,
      );
      testRide = Ride(
        driver: testDriver,
        passengers: [],
        route: Route(
          id: 1,
          start: testAddress, 
          end: farAddress,
        ),
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        estimatedArrivalTime: DateTime.now().add(const Duration(hours: 6)),
        estimatedDuration: const Duration(hours: 1),
        totalSeats: 4,
      );
      testRequest = RideRequest(
        id: 1,
        origin: testAddress, 
        destination: farAddress,
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        arrivalTime: DateTime.now().add(const Duration(hours: 6)),
        originRadius: Distance.withRadius(10000),  
        destinationRadius: Distance.withRadius(10000), 
        departureWindow: const Duration(minutes: 15),
        arrivalWindow: const Duration(minutes: 15),
      );
      // Set both radii to 10,000 meters (10km)
      testRequest = RideRequest(
        id: 1,
        origin: testAddress,
        destination: farAddress,
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        arrivalTime: DateTime.now().add(const Duration(hours: 6)),
        originRadius: Distance.withRadius(10000),        
        destinationRadius: Distance.withRadius(10000),   
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
      await rideRepository.create(testRide);
      await rideRepository.create(testRide);
      
      final rides = await rideRepository.fetchAllRides();
      expect(rides.length, initialRides + 3);
      expect(rides[initialRides].id, 0);
      expect(rides[initialRides+1].id, 1);
      expect(rides[initialRides+2].id, 2);
      //expect(rides.any((r) => r.id == testRide.id), isTrue);
  
    });

  test('clearHistory clears the ride history', () async {
        await rideRepository.clearHistory();
        final history = await rideRepository.fetchHistory();
        expect(history, isEmpty);
      });


    test('watchMatchingRides emits rides within 10km of origin (should match)', () async {
      await rideRepository.clearHistory();

      // Ride and request at the same address (distance = 0)
      await rideRepository.create(testRide);
      final stream = rideRepository.watchMatchingRides(testRequest);

      final distance = Distance();
      final origin = testRequest.origin.coordinates;
      final radius = testRequest.originRadius.radius;

      expectLater(
        stream,
        emits(
          predicate<List<Ride>>(
            (rides) => rides.any(
              (ride) => distance(origin, ride.route.start.coordinates) < radius,
            ),
          ),
        ),
      );
    });

    test('watchMatchingRides emits no rides if all are farther than 10km', () async {
      await rideRepository.clearHistory();

      // Create a ride at a far address
      final farLatLng = LatLng(0, 0); // >10km from Athens
      final farAddress = Address(
        id: 1,
        coordinates: farLatLng,
        city: 'FarTown',
        street: 'Far St',
        number: 2,
        postalCode: '54321',
      );
      final farRide = Ride(
        id: 1,
        driver: testDriver,
        passengers: [],
        route: Route(
          id: 1,
          start: farAddress,
          end: farAddress,
        ),
        departureTime: DateTime.now().add(const Duration(hours: 5)),
        estimatedArrivalTime: DateTime.now().add(const Duration(hours: 6)),
        estimatedDuration: const Duration(hours: 1),
        totalSeats: 4,
      );

      await rideRepository.create(farRide);

      // The request is still at testAddress (Athens)
      final stream = rideRepository.watchMatchingRides(testRequest);

      expectLater(
        stream,
        emits(
          predicate<List<Ride>>((rides) => rides.isEmpty),
        ),
      );
    });

    test('fetchHistory returns ride history', () async {
      await rideRepository.clearHistory();
      await rideRepository.create(testRide);
      final history = await rideRepository.fetchHistory();
      expect(history, isA<List<Ride>>());
      expect(history.isNotEmpty, isTrue);
      expect(history.any((r) => r.id == testRide.id && r.driver.id == testDriver.id), isTrue);
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
    await rideRepository.create(testRide); //does not have passengers yet
      final updatedRide = Ride(
        driver: testDriver,
        passengers: [testPassenger], //update to have passengers
        route: testRide.route,
        departureTime: testRide.departureTime,
        estimatedArrivalTime: testRide.estimatedArrivalTime,
        estimatedDuration: testRide.estimatedDuration,
        totalSeats: testRide.totalSeats,
        id: testRide.id, // Make sure id is set if required by your Ride model
      );
      await rideRepository.update(updatedRide, testRide.id);
      final rides = await rideRepository.fetchAllRides();
      final updated = rides.firstWhere((r) => r.id == testRide.id);
      expect(updated.passengers.first.id, testPassenger.id);
    });

    test('cancel removes a ride', () async {
      await rideRepository.create(testRide);
      await rideRepository.cancel(testRide);
      final rides = await rideRepository.fetchAllRides();
      expect(rides.any((r) => r.id == testRide.id), isFalse);
    });


  });
}