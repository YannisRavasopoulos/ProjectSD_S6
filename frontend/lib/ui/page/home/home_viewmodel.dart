import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  final LocationRepository locationRepository;
  final UserRepository userRepository;
  User? user;

  HomeViewModel({
    required this.locationRepository,
    required this.userRepository,
  }) {
    _init();
  }

  late final StreamSubscription<Location>? _locationSubscription;

  void _init() async {
    user = await userRepository.fetchCurrent();
    _locationSubscription = locationRepository
        .watchCurrent(user!)
        .listen(_onLocationUpdate);
    await refreshLocation();
  }

  void _onLocationUpdate(Location location) {
    _location = location;
    source = location.coordinates;
    notifyListeners();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Location? _location;
  LatLng? destination;
  LatLng source = LatLng(0, 0);

  List<String> suggestions = [];

  Future<void> refreshLocation() async {
    try {
      var location = await locationRepository.fetchCurrent(user!);
      _onLocationUpdate(location);
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void search(String query) async {
    suggestions.add("NIGGA");
    notifyListeners();
  }

  void selectSuggestion(String suggestion) async {
    // Handle suggestion selection
  }

  Iterable<String> getSuggestions(TextEditingValue textEditingValue) {
    var query = textEditingValue.text;
    return suggestions.where((suggestion) => suggestion.contains(query));
  }

  Future<void> selectPoint(LatLng point) async {
    destination = point;
    print("Selected ${point}");
    notifyListeners();

    // var location = await _locationRepository.getLocation(point);
    // print(location.name);
  }
}
