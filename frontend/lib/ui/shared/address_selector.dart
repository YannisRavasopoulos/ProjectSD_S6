import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/ui/shared/map/here_marker.dart';
import 'package:frontend/ui/shared/map/open_street_maps_tile_layer.dart';
import 'package:latlong2/latlong.dart';

class AddressSelector extends StatefulWidget {
  final AddressRepository addressRepository;
  final ValueChanged<Address> onAddressSelected;

  AddressSelector({
    super.key,
    required this.addressRepository,
    required this.onAddressSelected,
  });

  @override
  State<AddressSelector> createState() => _AddressSelector();
}

class _AddressSelector extends State<AddressSelector>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  bool _isLoading = true;
  LatLng _center = LatLng(0, 0);
  Address? _address;

  void _getUserLocation() async {
    // Fetch the user's current location and update the map center
    var address = await widget.addressRepository.fetchCurrent();
    setState(() {
      _center = address.coordinates;
      _isLoading = false;
    });
  }

  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        cancelPreviousAnimations: false,
      );

  void _onMapTapped(TapPosition tapPosition, LatLng point) async {
    setState(() {
      _center = point;
    });

    var addresses = await widget.addressRepository.fetchForCoordinates(point);

    if (addresses.isEmpty) {
      _address = null;
      return;
    }

    _address = addresses[0];
    widget.onAddressSelected(addresses[0]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _animatedMapController.mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 13.0,
            onTap: _onMapTapped,
          ),
          children: [
            OpenStreetMapsTileLayer(),
            MarkerLayer(markers: [HereMarker(_center)]),
          ],
        ),
        Positioned(
          top: 4,
          left: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: [
                Text("${_center}"),
                if (_address != null) Text(_address.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }
}
