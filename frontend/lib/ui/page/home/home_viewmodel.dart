import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  Location? _location;

  LatLng? destination;
  LatLng source = const LatLng(0, 0); // Initialize to (0,0) coordinates

  List<String> suggestions = [];

  Future<void> search(String query) async {
    suggestions.add("NIGGA");
    notifyListeners();
  }

  Future<void> selectSuggestion(int index) async {
    // Handle suggestion selection
  }

  Iterable<String> getSuggestions(TextEditingValue textEditingValue) {
    var query = textEditingValue.text;
    return suggestions.where((suggestion) => suggestion.contains(query));
  }

  Future<void> selectPoint(LatLng point) async {
    destination = point;
    notifyListeners();

    // var location = await _locationRepository.getLocation(point);
    // print(location.name);
  }

  Future<void> refreshLocation() async {
    try {
      _location = await _locationRepository.getCurrentLocation();
      source = _location!.coordinates;
      notifyListeners();
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
