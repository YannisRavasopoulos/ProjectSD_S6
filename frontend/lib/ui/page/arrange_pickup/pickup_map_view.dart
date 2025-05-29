import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/config.dart';

class PickupMapView extends StatelessWidget {
  final Location location;
  final Function(Location) onLocationChanged;

  const PickupMapView({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLocation = location.coordinates.latitude != 0.0 ||
            location.coordinates.longitude != 0.0
        ? location.coordinates
        : null;

    final mapController = MapController();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            onLocationChanged(
              ImplLocation(
                id: DateTime.now().millisecondsSinceEpoch,
                name: 'Custom Location',
                coordinates: point,
              ),
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
                  point: selectedLocation,
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
}
