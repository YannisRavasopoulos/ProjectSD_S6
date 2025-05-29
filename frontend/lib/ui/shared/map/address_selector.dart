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
  late final AnimatedMapController _animatedMapController =
      AnimatedMapController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        cancelPreviousAnimations: false,
      );

  LatLng _center = LatLng(0, 0); // Example: Athens, Greece
  Address? _address;

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  void _onMapTapped(TapPosition tapPosition, LatLng point) async {
    setState(() {
      _center = point;
    });

    var address = await widget.addressRepository.fetchForCoordinates(point);
    _address = address[0];
    widget.onAddressSelected(_address!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
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
      ),
    );
  }
}
