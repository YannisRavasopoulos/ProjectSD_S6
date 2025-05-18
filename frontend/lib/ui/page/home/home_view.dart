import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/config.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/shared/bottom_panel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> with TickerProviderStateMixin {
  MapController get mapController => _customMapController.mapController;

  void _onLocationClick() async {
    await widget.viewModel.refreshLocation();
    _customMapController.animateTo(
      dest: widget.viewModel.location.coordinates,
      zoom: 15.0,
    );
  }

  late final AnimatedMapController _customMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    cancelPreviousAnimations: false,
  );

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
                  initialCenter: widget.viewModel.location.coordinates,
                  initialZoom: 8,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: Config.packageName,
                  ),
                  // MarkerLayer(
                  //   markers: [
                  //     Marker(
                  //       point: LatLng(51.509364, -0.128928),
                  //       child: Icon(
                  //         Icons.location_on,
                  //         color: Colors.red,
                  //         size: 40.0,
                  //       ),
                  //     ),
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
            ],
          );
        },
      ),
      bottomNavigationBar: BottomPanel(currentIndex: 0),

      floatingActionButton: FloatingActionButton(
        onPressed: _onLocationClick,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
