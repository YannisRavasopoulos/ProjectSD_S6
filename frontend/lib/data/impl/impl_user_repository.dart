import 'dart:async';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ImplUser extends User {
  @override
  final int id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int points;
  @override
  String get name => '$firstName $lastName';

  ImplUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.points,
  });

  ImplUser copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? points,
  }) {
    return ImplUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      points: points ?? this.points,
    );
  }
}

class ImplUserRepository implements UserRepository {
  static final ImplUser _defaultUser = ImplUser(
    id: 0,
    firstName: 'John',
    lastName: 'Doe',
    points: 300,
  );

  ImplUser? _currentUser;
  final _userController = StreamController<User>.broadcast();

  Future<void> updateCurrentUser(User user) async {
    try {
      if (user is ImplUser) {
        _currentUser = user; // Store the updated user
        _userController.add(user); // Notify listeners
        return Future.value(); // Explicitly return success
      } else {
        throw Exception('Invalid user type');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<User> fetchCurrent() async {
    try {
      if (_currentUser == null) {
        _currentUser = _defaultUser;
      }
      return _currentUser!;
    } catch (e) {
      return Future.error('Failed to fetch current user: $e');
    }
  }

  @override
  Stream<User> watchCurrent() async* {
    try {
      yield await fetchCurrent();
      yield* _userController.stream;
    } catch (e) {
      yield* Stream.error('Failed to watch current user: $e');
    }
  }

  void dispose() {
    _userController.close();
  }
}
