import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/model.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/data/model/ride.dart';

class PickupRequest extends Model {
  final Ride ride;
  final Passenger passenger;
  final Address address;
  final DateTime time;

  PickupRequest({
    required super.id,
    required this.ride,
    required this.passenger,
    required this.address,
    required this.time,
  });
}
