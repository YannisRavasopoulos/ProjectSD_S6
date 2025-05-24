import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';

class MockUser extends User {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int points;

  MockUser({
    required this.firstName,
    required this.lastName,
    required this.points,
  });

  factory MockUser.random() {
    return MockUser(firstName: 'John', lastName: 'Doe', points: 300);
  }
}

class MockUserRepository extends UserRepository {
  User _user = MockUser.random();

  @override
  Future<User> fetchCurrent() async {
    return _user;
  }

  @override
  Stream<User> watchCurrent() async* {
    while (true) {
      // Simulate a delay for fetching data
      await Future.delayed(const Duration(seconds: 10));
      yield await fetchCurrent();
    }
  }
}
