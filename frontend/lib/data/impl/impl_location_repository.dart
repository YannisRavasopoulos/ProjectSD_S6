import 'dart:async';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

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

class ImplLocationRepository implements LocationRepository {
  final GeoCode _geoCodeApi = GeoCode();

  @override
  Future<Location> fetchCurrent(User user) async {
    // έλεγχος αν είναι ενεργοποιημένο το location
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied.');
    }

    // παίρνουμε το τρέχον position
    Position position = await Geolocator.getCurrentPosition();
    // reverse geocoding για να πάρουμε όνομα τοποθεσίας
    Address address = await _geoCodeApi.reverseGeocoding(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return ImplLocation(
      id: user.hashCode,
      name:
          address.streetAddress ?? '${position.latitude},${position.longitude}',
      coordinates: LatLng(position.latitude, position.longitude),
    );
  }

  @override
  Stream<Location> watchCurrent(User user) async* {
    while (true) {
      yield await fetchCurrent(user);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Future<Location> fetchForQuery(String query) async {
    // Geocoding για να βρούμε συντεταγμένες από query string
    Coordinates coords = await _geoCodeApi.forwardGeocoding(address: query);
    return ImplLocation(
      id: query.hashCode,
      name: query,
      coordinates: LatLng(coords.latitude!, coords.longitude!),
    );
  }
}
