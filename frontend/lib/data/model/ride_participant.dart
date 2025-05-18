import 'dart:math';

class RideParticipant /* extends User */ {
  String name;

  RideParticipant({required this.name});

  factory RideParticipant.random() {
    final names = ["John Doe", "Jane Smith", "Alice Johnson", "Bob Brown"];
    final random = Random();
    return RideParticipant(name: names[random.nextInt(names.length)]);
  }
}
