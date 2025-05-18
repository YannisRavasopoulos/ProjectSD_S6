import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/config.dart';

class PickupMapView extends StatefulWidget {
  final Function(String) onLocationChanged;

  const PickupMapView({super.key, required this.onLocationChanged});

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
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
      child: FlutterMap(
        mapController: _customMapController.mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
              widget.onLocationChanged('${point.latitude},${point.longitude}');
            });
          },
          initialCenter: const LatLng(0, 0),
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
