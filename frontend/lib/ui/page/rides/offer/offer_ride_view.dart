import 'package:flutter/material.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/ui/page/rides/offer/offer_ride_viewmodel.dart';

class OfferRideView extends StatelessWidget {
  final OfferRideViewModel viewModel;

  const OfferRideView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("Offer Ride")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Potential Passengers",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                if (viewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (viewModel.potentialPassengers.isEmpty)
                  const Center(child: Text("No potential passengers found."))
                else
                  Expanded(child: _buildPotentialPassengerList(context)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPotentialPassengerList(BuildContext context) {
    if (viewModel.potentialPassengers.isEmpty) {
      return const Center(child: Text("No potential passengers found."));
    }
    return ListView.separated(
      itemCount: viewModel.potentialPassengers.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final passenger = viewModel.potentialPassengers[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(passenger.name.isNotEmpty ? passenger.name[0] : "?"),
          ),
          title: Text(passenger.name),
          subtitle: Text("No details available"),
          trailing: ElevatedButton(
            onPressed: () => _onOfferRidePressed(context, passenger),
            child: const Text("Offer Ride"),
          ),
        );
      },
    );
  }

  void _onOfferRidePressed(BuildContext context, User user) async {
    var pickupRequest = await viewModel.offerRide(user);
    Navigator.of(
      context,
    ).pushReplacementNamed('/pickups/arrange', arguments: pickupRequest);
  }
}
