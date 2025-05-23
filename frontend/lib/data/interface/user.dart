// import 'package:frontend/data/authentication.dart';
// import 'package:frontend/data/model/location.dart';
// import 'package:frontend/data/model/reward.dart';
// import 'package:frontend/data/model/ride.dart';
// import 'package:frontend/data/model/user.dart';

import 'package:latlong2/latlong.dart';

abstract class Model {
  int get id;
  DateTime get lastUpdated;
}

abstract class User {
  String get firstName;
  String get lastName;
  int get points;
}

abstract interface class Authentication {}

abstract interface class UserRepository {
  /// Fetch user data.
  Future<User> fetch(Authentication authentication);

  /// Watches for changes in the user data.
  Stream<User> watch(Authentication authentication);

  /// Updates the user data.
  Future<void> update(User user);

  /// Deletes the user data.
  Future<void> delete(User user);

  /// Creates a new user.
  Future<void> create(User user);
}

abstract interface class Driver {}

abstract interface class Passenger {}

abstract interface class Vehicle {}

abstract interface class Route {}

abstract interface class Activity {}
