import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/config.dart';

class PickupMapView extends StatefulWidget {
  final Location location;
  final Function(Location) onLocationChanged;

  const PickupMapView({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  State<PickupMapView> createState() => _PickupMapViewState();
}

class _PickupMapViewState extends State<PickupMapView>
    with TickerProviderStateMixin {
  late final AnimatedMapController _customMapController;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _customMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      cancelPreviousAnimations: false,
    );
    if (widget.location.coordinates.latitude != 0.0 ||
        widget.location.coordinates.longitude != 0.0) {
      selectedLocation = widget.location.coordinates;
    }
  }

  @override
  void didUpdateWidget(covariant PickupMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location.coordinates != oldWidget.location.coordinates) {
      setState(() {
        selectedLocation = widget.location.coordinates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: _customMapController.mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
            });
            widget.onLocationChanged(
              ImplLocation(id: 0, name: '', coordinates: point),
            );
          },
          initialCenter: selectedLocation ?? const LatLng(0, 0),
          initialZoom: 8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: Config.packageName,
          ),
          MarkerLayer(
            markers: [
              if (selectedLocation != null)
                Marker(
                  point: selectedLocation!,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 32.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customMapController.dispose();
    super.dispose();
  }
}
