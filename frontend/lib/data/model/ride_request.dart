import 'package:frontend/data/model/address.dart';
import 'package:latlong2/latlong.dart';

abstract class RideRequest {
  final Address origin;
  final Address destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final Distance originRadius; // eg within 5km from origin
  final Distance destinationRadius; // same for destination
  final Duration departureWindow; // eg +/- 15 minutes from departureTime
  final Duration arrivalWindow; // same for arrival

  RideRequest({
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.originRadius,
    required this.destinationRadius,
    required this.departureWindow,
    required this.arrivalWindow,
  });
}
