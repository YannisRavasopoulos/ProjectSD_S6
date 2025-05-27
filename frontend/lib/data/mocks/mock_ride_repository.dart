// import 'package:frontend/data/mocks/mock_location_repository.dart';
// import 'package:frontend/data/model/driver.dart';
// import 'package:frontend/data/model/location.dart';
// import 'package:frontend/data/model/passenger.dart';
// import 'package:frontend/data/model/ride.dart';
// import 'package:frontend/data/model/ride_request.dart';
// import 'package:frontend/data/model/route.dart';
// import 'package:frontend/data/model/user.dart';
// import 'package:frontend/data/repository/ride_repository.dart';
// import 'package:latlong2/latlong.dart';

// class MockRoute extends Route {
//   @override
//   final int id = 0;
//   @override
//   final Location start;
//   @override
//   final Location end;

//   MockRoute({required this.start, required this.end});

//   factory MockRoute.random() {
//     return MockRoute(start: MockLocation.random(), end: MockLocation.random());
//   }
// }

// class MockPassenger extends Passenger {
//   @override
//   final String firstName;
//   @override
//   final String lastName;
//   @override
//   final int points;
//   @override
//   final int id = 0;

//   MockPassenger({
//     required this.firstName,
//     required this.lastName,
//     required this.points,
//   });

//   factory MockPassenger.random() {
//     return MockPassenger(firstName: 'John', lastName: 'Doe', points: 300);
//   }
// }

// class MockRideRequest extends RideRequest {
//   @override
//   final Location origin;
//   @override
//   final Location destination;
//   @override
//   final DateTime departureTime;
//   @override
//   final DateTime arrivalTime;
//   @override
//   final int id = 0;

//   @override
//   final Duration arrivalWindow = Duration(seconds: 0);

//   @override
//   final Duration departureWindow = Duration(seconds: 0);

//   @override
//   final Distance destinationRadius = Distance.withRadius(1);

//   @override
//   final Distance originRadius = Distance.withRadius(1);

//   MockRideRequest({
//     required this.origin,
//     required this.destination,
//     required this.departureTime,
//     required this.arrivalTime,
//   });
// }

// class MockDriver extends Driver {
//   @override
//   final int id = 0;
//   @override
//   final String firstName;
//   @override
//   final String lastName;
//   @override
//   final int points;

//   MockDriver({
//     required this.firstName,
//     required this.lastName,
//     required this.points,
//   });

//   factory MockDriver.random() {
//     return MockDriver(firstName: 'John', lastName: 'Doe', points: 300);
//   }
// }

// class MockRide extends Ride {
//   @override
//   final int id = 0;

//   @override
//   final Driver driver;

//   @override
//   final List<Passenger> passengers;

//   @override
//   final Route route;

//   @override
//   final DateTime departureTime;

//   @override
//   final DateTime estimatedArrivalTime;

//   @override
//   final Duration estimatedDuration;

//   @override
//   final int availableSeats;

//   @override
//   final int totalSeats;

//   MockRide({
//     required this.driver,
//     required this.passengers,
//     required this.route,
//     required this.departureTime,
//     required this.estimatedArrivalTime,
//     required this.estimatedDuration,
//     required this.availableSeats,
//     required this.totalSeats,
//   });

//   factory MockRide.random() {
//     return MockRide(
//       driver: MockDriver.random(),
//       passengers: [],
//       route: MockRoute.random(),
//       departureTime: DateTime.now(),
//       estimatedArrivalTime: DateTime.now(),
//       estimatedDuration: Duration.zero,
//       availableSeats: 4,
//       totalSeats: 4,
//     );
//   }
// }

// class MockRideRepository implements RideRepository {
//   List<Ride> _rideHistory = [
//     MockRide.random(),
//     MockRide.random(),
//     MockRide.random(),
//   ];

//   @override
//   Future<void> cancel(Ride ride) {
//     // TODO: implement cancel
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> create(Ride ride) {
//     // TODO: implement create
//     throw UnimplementedError();
//   }

//   @override
//   Future<Ride> fetchCurrent() {
//     // TODO: implement fetchCurrent
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Ride>> fetchMatchingRides(RideRequest request) {
//     // TODO: implement fetchMatching
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<Ride>> watchMatchingRides(RideRequest request) {
//     // TODO: implement watchMatching
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> join(Ride ride) {
//     // TODO: implement join
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> leave(Ride ride) {
//     // TODO: implement leave
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> update(Ride ride) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }

//   @override
//   Stream<Ride> watchCurrent() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Ride>> fetchHistory() async {
//     return _rideHistory;
//   }

//   @override
//   Stream<List<Ride>> watchHistory() async* {
//     while (true) {
//       await Future.delayed(const Duration(seconds: 5));
//       yield await fetchHistory();
//     }
//   }

//   @override
//   Future<void> clearHistory() async {
//     _rideHistory.clear();
//   }

//   @override
//   Future<User> fetchPotentialPassengers(Ride ride) {
//     // TODO: implement fetchPotentialPassengers
//     throw UnimplementedError();
//   }

//   @override
//   Stream<List<User>> watchPotentialPassengers(Ride ride) {
//     // TODO: implement watchPotentialPassengers
//     throw UnimplementedError();
//   }
// }
