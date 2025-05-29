import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/ride.dart';

abstract class Pickup extends PickupRequest implements Model {
  Ride get ride;
  Passenger get passenger;
  Address get address;
  DateTime get time;
}
