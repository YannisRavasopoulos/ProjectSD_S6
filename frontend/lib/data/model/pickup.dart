import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

class Pickup {
  final Ride ride;
  final Passenger passenger;
  final Address address;
  final DateTime time;

  Pickup({
    required this.ride,
    required this.passenger,
    required this.time,
    required this.address,
  });
}
