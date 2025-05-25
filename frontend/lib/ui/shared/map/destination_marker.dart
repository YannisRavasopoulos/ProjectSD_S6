import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class DestinationMarker extends Marker {
  DestinationMarker(point)
    : super(
        point: point,
        child: Builder(
          builder: (context) {
            return const Icon(
              Icons.circle,
              color: Color.fromARGB(255, 255, 0, 0), // Red color
              size: 16.0,
            );
          },
        ),
      );
}
