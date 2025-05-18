import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:frontend/config.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/shared/bottom_panel.dart';
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

  void _onLongPress(TapPosition tapPosition, LatLng point) {
    widget.viewModel.selectPoint(point);
  }

  void _onMenuPressed() {}

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
                  onLongPress:
                      (tapPosition, point) => _onLongPress(tapPosition, point),
                  initialCenter: widget.viewModel.source ?? LatLng(0, 0),
                  initialZoom: 8,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: Config.packageName,
                  ),
                  MarkerLayer(
                    markers: [
                      if (widget.viewModel.destination != null)
                        Marker(
                          point: widget.viewModel.destination!,
                          child: Builder(
                            builder: (context) {
                              return const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 32.0,
                              );
                            },
                          ),
                        ),
                      Marker(
                        point: widget.viewModel.source ?? LatLng(0, 0),
                        child: Builder(
                          builder: (context) {
                            return const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 32.0,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 143, 117),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard), // Added rewards icon
              title: const Text('Rewards'), // Added rewards title
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/rewards',
                ); // Navigate to rewards view
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Find Ride'),
              onTap: () {
                Navigator.pushNamed(context, '/find_ride');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomPanel(routeName: "/home"),
      floatingActionButton: FloatingActionButton(
        onPressed: _onLocationPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
