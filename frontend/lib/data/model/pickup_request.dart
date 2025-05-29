import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

class PickupRequest {
  final Ride ride;
  final Passenger passenger;
  final Address address;
  final DateTime time;

  PickupRequest({
    required this.ride,
    required this.passenger,
    required this.address,
    required this.time,
  });
}
