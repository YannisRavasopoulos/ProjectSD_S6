import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  Location? _location;

  LatLng? destination;
  LatLng? source;

  void selectPoint(LatLng point) {
    destination = point;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    try {
      _location = await _locationRepository.getCurrentLocation();
      source = _location!.coordinates;
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
