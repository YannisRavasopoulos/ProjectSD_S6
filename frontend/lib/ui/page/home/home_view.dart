import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/ui/page/home/map_search_bar.dart';
import 'package:frontend/ui/shared/nav/app_drawer.dart';
import 'package:frontend/ui/shared/map/destination_marker.dart';
import 'package:frontend/ui/shared/map/here_marker.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/shared/map/open_street_maps_tile_layer.dart';
import 'package:frontend/ui/shared/nav/app_navigation_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/pickup.dart';
//testing
import 'package:frontend/ui/arrange_pickup/components/pickup_request_notification.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/ui/notification/notification_overlay.dart';
//
import 'package:frontend/data/service/notification_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> with TickerProviderStateMixin {
  MapController get mapController => _customMapController.mapController;

  void _onLocationPressed() async {
    await widget.viewModel.refreshLocation();
    _customMapController.animateTo(dest: widget.viewModel.source, zoom: 15.0);
  }

  late final AnimatedMapController _customMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    cancelPreviousAnimations: false,
  );

  void _onMapTapped(TapPosition tapPosition, LatLng point) {
    widget.viewModel.selectPoint(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Stack(
            children: [
              // Map as the background
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: _onMapTapped,
                  initialCenter: widget.viewModel.source,
                  initialZoom: 8,
                ),
                children: [
                  OpenStreetMapsTileLayer(),
                  MarkerLayer(
                    markers: [
                      HereMarker(widget.viewModel.source),
                      if (widget.viewModel.destination != null)
                        DestinationMarker(widget.viewModel.destination),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: MapSearchBar(
                  suggestions: widget.viewModel.suggestions,
                  onSearchChanged: (value) {
                    widget.viewModel.search(value);
                  },
                  onSuggestionSelected: (index) {
                    widget.viewModel.selectSuggestion(index);
                  },
                  hintText: 'Search for a location...',
                ),
              ),
            ],
          );
        },
      ),
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search for a location...',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          onSubmitted: (value) {
            // Handle search logic here
            print('Search query: $value');
          },
        ),
      ),

      drawer: AppDrawer(),
      bottomNavigationBar: AppNavigationBar(routeName: "/home"),
      floatingActionButton: FloatingActionButton(
        onPressed: _onLocationPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
