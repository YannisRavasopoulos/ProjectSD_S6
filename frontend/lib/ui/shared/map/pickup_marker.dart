import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickupMarker extends Marker {
  PickupMarker(LatLng point)
    : super(
        point: point,
        child: Builder(
          builder: (context) {
            return const Icon(
              Icons.person_pin_circle,
              color: Color.fromARGB(255, 255, 56, 189), // Blue color
              size: 32.0,
            );
          },
        ),
      );
}
