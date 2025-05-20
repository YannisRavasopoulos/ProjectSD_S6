import 'package:latlong2/latlong.dart';

class Location {
  final LatLng coordinates;
  final String name;
  // final String address;
  // final String city;

  const Location({required this.coordinates, required this.name});

  Location.random()
    : coordinates = LatLng(
        37.7749 + (0.1 * (DateTime.now().millisecondsSinceEpoch % 100)),
        -122.4194 + (0.1 * (DateTime.now().millisecondsSinceEpoch % 100)),
      ),
      name = 'Location ${DateTime.now().millisecondsSinceEpoch}';

  // final String name;
}
