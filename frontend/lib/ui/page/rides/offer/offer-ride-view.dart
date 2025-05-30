import 'package:flutter/material.dart';
import 'package:frontend/ui/page/rides/offer/offer_ride_viewmodel.dart';
import 'package:frontend/ui/page/rides/offer/offer-ride-card.dart';
import 'package:frontend/ui/page/rides/offer/select_passenger_popup.dart';

class OfferRideView extends StatelessWidget {
  final OfferRideViewModel viewModel;

  const OfferRideView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.loadRides(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: viewModel.rides.length,
          itemBuilder: (context, index) {
            final ride = viewModel.rides[index];
            return RideCard(
              ride: ride,
              onOfferRidePressed: () async {
                await viewModel.loadMatchingPassengers(ride);
                final passengers = viewModel.getPassengersForRide(ride);
                final selected = await showDialog<List>(
                  context: context,
                  builder:
                      (context) => SelectPassengerPopup(passengers: passengers),
                );
                if (selected != null) {
                  await viewModel.offerRide(ride, selected);
                }
              },
            );
          },
        );
      },
    );
  }
}
