import 'package:frontend/data/location_exception.dart';
import 'package:frontend/data/model/location.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationRepository {
  GeoCode _geoCodeApi = GeoCode();

  // Watch for changes in current location
  Stream<Location> watchCurrent() async* {
    while (true) {
      // Update every 5 seconds
      yield await fetchCurrent();
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<Location> fetchForCoordinates(LatLng coordinates) async {
    var address = await _geoCodeApi.reverseGeocoding(
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
    );

    return Location(id: 1, coordinates: coordinates, name: address.toString());
  }

  Future<Location> fetchCurrent() async {
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
    var location = await fetchForCoordinates(
      LatLng(position.latitude, position.longitude),
    );

    return location;
  }
}
