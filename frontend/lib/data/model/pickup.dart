import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

class Pickup extends Model {
  final Ride ride;
  final Passenger passenger;
  final Address address;
  final DateTime time;

  Pickup({
    required super.id,
    required this.ride,
    required this.passenger,
    required this.time,
    required this.address,
  });
}
