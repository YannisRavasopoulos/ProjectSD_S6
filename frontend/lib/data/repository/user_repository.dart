import 'package:frontend/data/model/user.dart';

class UserRepository {
  User _user = User.random();

  Future<User> fetch() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    return _user;
  }

  Future<User> fetchForId(int id) async {
    return _user;
  }

  Stream<User> watch() async* {
    while (true) {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      yield _user;
    }
  }

  Future<void> update(User user) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    _user = user;
  }

  Future<void> delete() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    _user = User(id: 0, firstName: '', lastName: '', points: 0);
  }

  Future<void> create(User user) async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
    _user = user;
  }
}
