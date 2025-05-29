import 'package:frontend/data/model.dart';
import 'package:frontend/data/model/address.dart';
import 'package:latlong2/latlong.dart';

abstract class RideRequest implements Model {
  Address get origin;
  Address get destination;

  DateTime get departureTime;
  DateTime get arrivalTime;

  Distance get originRadius; // eg within 5km from origin
  Distance get destinationRadius; // same for destination

  Duration get departureWindow; // eg +/- 15 minutes from departureTime
  Duration get arrivalWindow; // same for arrival
}
