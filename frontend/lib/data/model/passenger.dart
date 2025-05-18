import 'package:frontend/data/model/ride_participant.dart';

class Passenger extends RideParticipant {
  Passenger({required String name}) : super(name: name);

  factory Passenger.random() {
    return Passenger(name: RideParticipant.random().name);
  }
}
