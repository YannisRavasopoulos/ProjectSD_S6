import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/ui/page/rides/ride_card.dart';

// ViewModel for Rides
class RidesViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  List<Ride> rides = [];

  RidesViewModel({required this.rideRepository});

  Future<void> fetchRides() async {
    rides = await rideRepository.fetchCreatedRides();
    notifyListeners();
  }
}

// The main RidesView
class RidesView extends StatelessWidget {
  final RidesViewModel viewModel;

  const RidesView({super.key, required this.viewModel});

  void _onOfferRidePressed(BuildContext context, Ride ride) {
    // viewModel.offerRide(ride);
    Navigator.pushNamed(context, '/rides/offer', arguments: ride);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("Rides")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Available Rides",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                if (viewModel.rides.isEmpty)
                  const Center(child: Text("No rides available."))
                else
                  Expanded(child: _buildRideList(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRideList(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.rides.length,
      itemBuilder: (context, index) {
        return RideCard(
          ride: viewModel.rides[index],
          onRidePressed:
              () => _onOfferRidePressed(context, viewModel.rides[index]),
          label: "Offer Ride",
        );
      },
    );
  }
}
