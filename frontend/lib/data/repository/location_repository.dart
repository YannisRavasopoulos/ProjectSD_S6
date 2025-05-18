import 'package:frontend/data/location_exception.dart';
import 'package:frontend/data/model/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationRepository {
  Future<Location> getLocation(LatLng coordinates) async {}

  Future<Location> getCurrentLocation() async {
    var isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw LocationException('Location services are disabled.');
    }

    // We must first get permission from the user

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permissions permanently denied.');
    }

    var position = await Geolocator.getCurrentPosition();

    return Location(
      coordinates: LatLng(position.latitude, position.longitude),
      name: "Current Location",
    );
  }
}
