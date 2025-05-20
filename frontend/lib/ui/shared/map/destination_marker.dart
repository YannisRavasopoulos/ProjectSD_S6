import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class DestinationMarker extends Marker {
  DestinationMarker(point)
    : super(
        point: point,
        child: Builder(
          builder: (context) {
            return const Icon(Icons.location_on, color: Colors.red, size: 32.0);
          },
        ),
      );
}
