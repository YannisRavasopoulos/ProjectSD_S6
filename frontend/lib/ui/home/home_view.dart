import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/config.dart';
import 'package:latlong2/latlong.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map as the background
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                51.509364,
                -0.128928,
              ), // Center the map over London
              initialZoom: 9.2,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: Config.packageName,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(51.509364, -0.128928),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                  Marker(
                    point: LatLng(51.503399, -0.119519), // London Eye
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                  Marker(
                    point: LatLng(51.500729, -0.124625), // Big Ben
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Search bar overlay
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a location...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                onSubmitted: (value) {
                  // Handle search logic here
                  print('Search query: $value');
                },
              ),
            ),
          ),
          // Add other UI elements (e.g., buttons)
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                // Handle button action
                print('Floating Action Button Pressed');
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
