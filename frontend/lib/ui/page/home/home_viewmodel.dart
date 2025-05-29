import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  final AddressRepository addressRepository;
  final UserRepository userRepository;

  // TODO: this should go to addressRepository
  Stream<Address> watchCurrentAddress() async* {
    var user = await userRepository.fetchCurrent();
    yield* addressRepository.watchCurrent(user);
  }

  // TODO: this should go to addressRepository
  Future<Address> fetchCurrentLocation() async {
    var user = await userRepository.fetchCurrent();
    return addressRepository.fetchCurrent(user);
  }

  bool shouldAnimateToLocation = true;

  LatLng? destination;
  LatLng currentLocation = LatLng(0, 0);
  List<String> suggestions = [];

  HomeViewModel({
    required this.addressRepository,
    required this.userRepository,
  }) {
    _locationSubscription = watchCurrentAddress().listen(_onAddressUpdate);
    refreshLocation();
  }

  late final StreamSubscription<Address> _locationSubscription;

  void _onAddressUpdate(Address location) {
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
      _onAddressUpdate(location);
      shouldAnimateToLocation = true;
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void search(String query) async {
    print(query);
    // TODO
    // var addresses = addressRepository.fetchForQuery(query);
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
