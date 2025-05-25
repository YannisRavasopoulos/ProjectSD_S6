import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';

abstract class PickupRequest implements Model {
  Passenger get passenger;
  Location get location;
  DateTime get time;
}
