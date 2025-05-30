import 'package:flutter/material.dart' hide Route;
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/ui/shared/map/destination_marker.dart';
import 'package:frontend/ui/shared/map/here_marker.dart';
import 'package:frontend/ui/shared/map/open_street_maps_tile_layer.dart';
import 'package:frontend/ui/shared/map/pickup_marker.dart';
import 'package:latlong2/latlong.dart';

class RouteView extends StatelessWidget {
  final Route route;
  final List<Pickup> pickups;

  const RouteView({super.key, required this.route, this.pickups = const []});

  LatLng midpoint() {
    final start = LatLng(
      route.start.coordinates.latitude,
      route.start.coordinates.longitude,
    );
    final end = LatLng(
      route.end.coordinates.latitude,
      route.end.coordinates.longitude,
    );
    return LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(route.start.coordinates);
    print(route.end.coordinates);

    print(pickups);

    return FlutterMap(
      options: MapOptions(
        initialCenter: midpoint(),
        initialZoom: 12,
        interactionOptions: InteractionOptions(),
      ),
      children: [
        OpenStreetMapsTileLayer(),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [
                LatLng(
                  route.start.coordinates.latitude,
                  route.start.coordinates.longitude,
                ),
                LatLng(
                  route.end.coordinates.latitude,
                  route.end.coordinates.longitude,
                ),
              ],
              color: Colors.blue,
              strokeWidth: 4.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            HereMarker(route.start.coordinates),
            DestinationMarker(route.end.coordinates),
            ...pickups.map(
              (pickup) => PickupMarker(
                LatLng(
                  pickup.address.coordinates.latitude,
                  pickup.address.coordinates.longitude,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
