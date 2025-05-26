import 'package:frontend/data/model/passenger.dart';

class ImplPassenger extends Passenger {
  @override
  final int id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int points;

  ImplPassenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.points,
    DateTime? createdAt,
  });

  factory ImplPassenger.test() {
    return ImplPassenger(
      id: 999,
      firstName: 'Test',
      lastName: 'Passenger',
      points: 100,
    );
  }
}
