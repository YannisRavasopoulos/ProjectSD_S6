import 'package:frontend/data/model/user.dart';

class RideParticipant /* extends User */ {
  String name = "John Doe";
}

class Driver extends RideParticipant {}

class Vehicle {
  String description = "Toyota Camry";
}

class Passenger extends RideParticipant {}

class Location {}

class DateTime {}

class Duration {}

class Ride {
  Driver driver = Driver();
  Vehicle vehicle = Vehicle();
  String distance = "10 km";
  String description = "Heading to the city center";
  String estimatedDuration = "30 minutes";
  String passengers = "2";
  int capacity = 4;

  // List<Passenger> passengers = [];
  // Location startLocation = Location();
  // Location endLocation = Location();
  // DateTime startTime = DateTime();
  // Duration estimatedDuration = Duration();
}
