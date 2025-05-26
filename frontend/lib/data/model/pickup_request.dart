import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

abstract class PickupRequest implements Model {
  Ride get ride;
  Passenger get passenger;
  Location get location;
  DateTime get time;
}
