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
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button navigation
      child: Scaffold(
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    onTap: _onMapTapped,
                    initialCenter:
                        widget.viewModel.source ??
                        const LatLng(45.5017, -73.5673),
                    initialZoom: 8,
                  ),
                  children: [
                    OpenStreetMapsTileLayer(),
                    MarkerLayer(
                      markers: [
                        if (widget.viewModel.source != null)
                          HereMarker(widget.viewModel.source!),
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
                    onSearchChanged: widget.viewModel.search,
                    onSuggestionSelected: widget.viewModel.selectSuggestion,
                    hintText: 'Search for a location...',
                  ),
                ),
              ],
            );
          },
        appBar: AppBar(
          title: const Text('Loop App'),
          backgroundColor: const Color.fromARGB(255, 23, 143, 117),
        ),
        drawer: AppDrawer(),
        bottomNavigationBar: AppNavigationBar(routeName: "/home"),
        floatingActionButton: FloatingActionButton(
          onPressed: _onLocationPressed,
          child: const Icon(Icons.my_location),
        ),
//                     ListTile(
//               leading: const Icon(Icons.directions_car),
//               title: const Text('My Rides'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/rides');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.add_circle_outline),
//               title: const Text('Create Ride'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/create_ride');
//               },

        
//               ListTile( //VGALTO EINAI GIA TEST 
//               leading: const Icon(Icons.report),
//               title: const Text('Report User (Test)'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/report');
//               },
//             ), //VGALTO STO TELOS EINAI GIA TEST
      ),
    );
  }
}
