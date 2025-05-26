import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class HereMarker extends Marker {
  HereMarker(point)
    : super(
        point: point,
        child: Builder(
          builder: (context) {
            return const Icon(
              Icons.circle,
              color: Color.fromARGB(255, 0, 107, 214), // Blue color
              size: 16.0,
            );
          },
        ),
      );
}
