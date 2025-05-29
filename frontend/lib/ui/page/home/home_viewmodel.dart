import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:latlong2/latlong.dart';

class HomeViewModel extends ChangeNotifier {
  final AddressRepository addressRepository;

  bool shouldAnimateToLocation = true;

  LatLng? destination;
  LatLng currentLocation = LatLng(0, 0);
  List<String> suggestions = [];

  HomeViewModel({required this.addressRepository}) {
    _locationSubscription = addressRepository.watchCurrent().listen(
      _onAddressUpdate,
    );
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
      var location = await addressRepository.fetchCurrent();
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
