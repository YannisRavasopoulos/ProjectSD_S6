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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: MapSearchBar(
                    suggestionsBuilder: widget.viewModel.getSuggestions,
                    onSearchChanged: (value) {
                      widget.viewModel.search(value);
                    },
                    onSuggestionSelected: (index) {
                      // widget.viewModel.selectSuggestion(index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // appBar: AppBar(title: const Text('Loop App')),
      drawer: AppDrawer(),
      bottomNavigationBar: AppNavigationBar(routeName: "/home"),
      floatingActionButton: FloatingActionButton(
        onPressed: _onLocationPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
