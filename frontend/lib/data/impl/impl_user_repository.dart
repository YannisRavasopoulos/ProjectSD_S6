import 'dart:async';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ImplUserRepository implements UserRepository {
  static final User _defaultUser = User(
    id: 0,
    firstName: 'John',
    lastName: 'Doe',
    points: 300,
  );

  User? _currentUser;
  final _userController = StreamController<User>.broadcast();
  @override
  Future<void> updateCurrentUser(User user) async {
    try {
      _currentUser = user; // Store the updated user
      _userController.add(user); // Notify listeners
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
