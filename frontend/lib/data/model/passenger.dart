import 'dart:math';

import 'package:frontend/data/model/user.dart';

class Passenger extends User {
  Passenger({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.points,
  });

  factory Passenger.fake() {
    final random = Random();
    final names = ['Alex', 'Sam', 'Jamie', 'Taylor', 'Jordan', 'Casey'];
    final surnames = ['Smith', 'Lee', 'Patel', 'Kim', 'Garcia', 'Brown'];
    final firstName = names[random.nextInt(names.length)];
    final lastName = surnames[random.nextInt(surnames.length)];
    final points = random.nextInt(200) + 50;

    return Passenger(
      id: 0,
      firstName: firstName,
      lastName: lastName,
      points: points,
    );
  }
}
