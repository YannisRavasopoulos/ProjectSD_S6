import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/user_repository.dart';

class MockUser extends User {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int points;
  @override
  final int id = 0;

  MockUser({
    required this.firstName,
    required this.lastName,
    required this.points,
  });

  factory MockUser.random() {
    return MockUser(firstName: 'John', lastName: 'Doe', points: 300);
  }

  MockUser copyWith({String? firstName, String? lastName, int? points}) {
    return MockUser(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      points: points ?? this.points,
    );
  }
}

class MockUserRepository implements UserRepository {
  static MockUser user = MockUser.random();

  @override
  Future<User> fetchCurrent() async {
    return user;
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
