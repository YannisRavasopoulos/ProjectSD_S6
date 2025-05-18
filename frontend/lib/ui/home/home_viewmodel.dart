import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  Location location = const Location(
    coordinates: LatLng(0, 0),
    name: "Unable to determine location",
  );

  Future<void> refreshLocation() async {
    try {
      location = await _locationRepository.getLocation();
      notifyListeners();

      // print("UPDATED");
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  final LocationRepository _locationRepository;

  HomeViewModel({required LocationRepository locationRepository})
    : _locationRepository = locationRepository {
    refreshLocation();
  }
}
