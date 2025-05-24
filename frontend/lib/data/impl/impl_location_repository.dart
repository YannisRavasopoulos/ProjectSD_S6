import 'package:frontend/data/model/location.dart';
import 'package:latlong2/latlong.dart';

class ImplLocation extends Location {
  @override
  final int id;
  @override
  final String name;
  @override
  final LatLng coordinates;

  ImplLocation({
    required this.id,
    required this.name,
    required this.coordinates,
  });
}