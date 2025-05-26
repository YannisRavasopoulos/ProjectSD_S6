import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  final LocationRepository locationRepository;
  final UserRepository userRepository;
  final AddressRepository addressRepository;

  // TODO: this should go to locationRepository
  Stream<Location> watchCurrentLocation() async* {
    var user = await userRepository.fetchCurrent();
    yield* locationRepository.watchCurrent(user);
  }

  // TODO: this should go to locationRepository
  Future<Location> fetchCurrentLocation() async {
    var user = await userRepository.fetchCurrent();
    return locationRepository.fetchCurrent(user);
  }

  bool shouldAnimateToLocation = true;

  LatLng? destination;
  LatLng currentLocation = LatLng(0, 0);
  List<String> suggestions = [];

  HomeViewModel({
    required this.locationRepository,
    required this.userRepository,
    required this.addressRepository,
  }) {
    _locationSubscription = watchCurrentLocation().listen(_onLocationUpdate);
    refreshLocation();
  }

  late final StreamSubscription<Location> _locationSubscription;

  void _onLocationUpdate(Location location) {
    currentLocation = location.coordinates;
    notifyListeners();
    if (shouldAnimateToLocation) {
      shouldAnimateToLocation = false; // Prevent further animations
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  Future<void> refreshLocation() async {
    try {
      var location = await fetchCurrentLocation();
      _onLocationUpdate(location);
      shouldAnimateToLocation = true;
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void search(String query) async {
    print(query);
    var addresses = addressRepository.fetchForQuery(query);
    notifyListeners();
  }

  void selectSuggestion(String suggestion) async {}

  Iterable<String> getSuggestions(TextEditingValue textEditingValue) {
    var query = textEditingValue.text;
    return suggestions.where((suggestion) => suggestion.contains(query));
  }

  Future<void> selectPoint(LatLng point) async {
    destination = point;
    print("Selected ${point}");
    notifyListeners();
  }
}
