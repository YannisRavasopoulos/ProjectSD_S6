import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/config.dart';

class PickupMapView extends StatefulWidget {
  final LatLng location;
  final ValueChanged<LatLng> onLocationChanged;

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
    if (widget.location.latitude != 0.0 || widget.location.longitude != 0.0) {
      selectedLocation = widget.location;
    }
  }

  @override
  void didUpdateWidget(covariant PickupMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.location != oldWidget.location) {
      setState(() {
        selectedLocation = widget.location;
      });
    }
  }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
            });
            widget.onLocationChanged(point);
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
