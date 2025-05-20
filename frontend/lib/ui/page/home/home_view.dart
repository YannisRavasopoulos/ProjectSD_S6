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

  late final AnimatedMapController _customMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    cancelPreviousAnimations: false,
  );

  void _onLocationPressed() async {
    await widget.viewModel.refreshLocation();
    _customMapController.animateTo(dest: widget.viewModel.source, zoom: 15.0);
  }

  void _onMapTapped(TapPosition tapPosition, LatLng point) {
    widget.viewModel.selectPoint(point);
  }

  void _showTestNotification() {
    final testRide = Ride.random();
    final testDriver = Driver.random();

    final pickup = Pickup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ride: testRide,
      driver: testDriver,
      carpoolerId: 'test_user_id',
      pickupTime: DateTime.now().add(const Duration(minutes: 30)),
      location: 'Test Location',
      status: 'requested',
    );

    Navigator.pop(context); // Close drawer first

    NotificationOverlay.show(
      context,
      PickupRequestNotification(
        pickup: pickup,
        onArrange: () => _handleArrangePickup(pickup),
        onDecline: () => _handleDeclinePickup(pickup.id),
      ),
    );
  }

  void _handleArrangePickup(Pickup pickup) {
    Navigator.pushNamed(
      context,
      '/arrange_pickup',
      arguments: {
        'carpoolerId': pickup.carpoolerId,
        'driverId': pickup.driver.id,
        'ride': pickup.ride,
      },
    );
  }

  Future<void> _handleDeclinePickup(String pickupId) async {
    final pickupService = PickupService();
    await pickupService.updatePickupStatus(
      pickupId: pickupId,
      status: 'declined',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loop App'),
        backgroundColor: const Color.fromARGB(255, 23, 143, 117),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          // Define a default center position
          final LatLng defaultCenter = const LatLng(
            45.5017,
            -73.5673,
          ); // Montreal coordinates

          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onTap: _onMapTapped,
                  initialCenter:
                      widget.viewModel.source ??
                      defaultCenter, // Provide default center
                  initialZoom: 8,
                ),
                children: [
                  OpenStreetMapsTileLayer(),
                  MarkerLayer(
                    markers: [
                      if (widget.viewModel.source != null)
                        HereMarker(widget.viewModel.source!), // Add null check
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
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Rewards'),
              onTap: () => Navigator.pushNamed(context, '/rewards'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Find Ride'),
              onTap: () => Navigator.pushNamed(context, '/find_ride'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Test Notification'),
              onTap: _showTestNotification,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/home"),
      floatingActionButton: FloatingActionButton(
        onPressed: _onLocationPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
