import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/config.dart';

class OpenStreetMapsTileLayer extends TileLayer {
  OpenStreetMapsTileLayer()
    : super(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: Config.packageName,
      );
}
