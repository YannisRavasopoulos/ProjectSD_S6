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

  factory ImplLocation.test(status) {
    if (status == 'start') {
      return ImplLocation(
        id: 1,
        name: 'Test Location START',
        coordinates: LatLng(48.8566, 2.3522),
      );
    } else if (status == 'end') {
      return ImplLocation(
        id: 1,
        name: 'Test Location END',
        coordinates: LatLng(48.8640, 2.3499),
      );
    }
    throw ArgumentError('Invalid location type: $status');
  }
}
