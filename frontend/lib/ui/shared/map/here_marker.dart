import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class HereMarker extends Marker {
  HereMarker(point)
    : super(
        point: point,
        child: Builder(
          builder: (context) {
            return const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 32.0,
            );
          },
        ),
      );
}
