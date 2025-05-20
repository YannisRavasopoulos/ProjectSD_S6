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
              // Map as the background
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: _onMapTapped,
                  initialCenter: widget.viewModel.source ?? LatLng(0, 0),
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
              MapSearchBar(),
              // Search bar overlay
              // Positioned(
              //   top: 16.0,
              //   left: 16.0,
              //   right: 16.0,
              //   child: Card(
              //     elevation: 4.0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     child: TextField(
              //       decoration: InputDecoration(
              //         hintText: 'Search for a location...',
              //         // prefixIcon: const Icon(Icons.search),
              //         prefixIcon: IconButton(
              //           onPressed: () => _onMenuPressed(),
              //           icon: const Icon(Icons.menu),
              //         ),
              //         border: InputBorder.none,
              //         contentPadding: const EdgeInsets.all(16.0),
              //       ),
              //       onSubmitted: (value) {
              //         // Handle search logic here
              //         print('Search query: $value');
              //       },
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
      appBar: AppBar(
        // title: TextField(
        //   decoration: InputDecoration(
        //     hintText: 'Search for a location...',
        //     border: InputBorder.none,
        //     contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        //   ),
        //   onSubmitted: (value) {
        //     // Handle search logic here
        //     print('Search query: $value');
        //   },
        // ),
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
