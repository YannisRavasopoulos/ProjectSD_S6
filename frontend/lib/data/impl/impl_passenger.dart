import 'dart:math';

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
    final random = Random();
    final id = random.nextInt(1000) + 1;
    final names = ['Alex', 'Sam', 'Jamie', 'Taylor', 'Jordan', 'Casey'];
    final surnames = ['Smith', 'Lee', 'Patel', 'Kim', 'Garcia', 'Brown'];
    final firstName = names[random.nextInt(names.length)];
    final lastName = surnames[random.nextInt(surnames.length)];
    final points = random.nextInt(200) + 50;

    return ImplPassenger(
      id: id,
      firstName: firstName,
      lastName: lastName,
      points: points,
    );
  }
}
