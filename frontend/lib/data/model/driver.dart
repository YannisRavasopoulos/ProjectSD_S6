import 'package:frontend/data/model/ride_participant.dart';

class Driver extends RideParticipant {
  Driver({required String name}) : super(name: name);

  factory Driver.random() {
    return Driver(name: RideParticipant.random().name);
  }
}
