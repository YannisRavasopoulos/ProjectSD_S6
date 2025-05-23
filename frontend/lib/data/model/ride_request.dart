import 'package:frontend/data/model/location.dart';
import 'package:latlong2/latlong.dart';

abstract class RideRequest {
  Location get origin;
  Location get destination;

  DateTime get departureTime;
  DateTime get arrivalTime;

  Distance get originRadius; // eg within 5km from origin
  Distance get destinationRadius; // same for destination

  Duration get departureWindow; // eg +/- 15 minutes from departureTime
  Duration get arrivalWindow; // same for arrival
}
