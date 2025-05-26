import 'package:frontend/data/model/ride_request.dart';
import 'package:frontend/data/model/location.dart';
import 'package:latlong2/latlong.dart';

class ImplRideRequest implements RideRequest {
  @override
  final int id;
  @override
  final Location origin;
  @override
  final Location destination;
  @override
  final DateTime departureTime;
  @override
  final DateTime arrivalTime;
  @override
  final Distance originRadius;
  @override
  final Distance destinationRadius;
  @override
  final Duration departureWindow;
  @override
  final Duration arrivalWindow;

  ImplRideRequest({
    required this.id,
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
