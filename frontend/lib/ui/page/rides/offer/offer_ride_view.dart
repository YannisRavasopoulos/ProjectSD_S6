import 'package:flutter/material.dart';
import 'package:frontend/ui/page/rides/offer/activities_list.dart';
import 'package:frontend/ui/page/rides/offer/created_ride_list.dart';
import 'package:frontend/ui/page/rides/offer/offer_ride_mode_selector.dart';
import 'package:frontend/ui/page/rides/offer/offer_ride_viewmodel.dart';

enum OfferRideMode { createdRides, activities }

class OfferRideView extends StatelessWidget {
  final OfferRideViewModel viewModel;

  const OfferRideView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final modeNotifier = ValueNotifier<OfferRideMode>(
      OfferRideMode.createdRides,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offer Ride'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Column(
        children: [
          OfferRideModeSelector(modeNotifier: modeNotifier),
          Expanded(
            child: ValueListenableBuilder<OfferRideMode>(
              valueListenable: modeNotifier,
              builder: (context, mode, _) {
                if (mode == OfferRideMode.createdRides) {
                  return AnimatedBuilder(
                    animation: viewModel,
                    builder:
                        (context, _) => CreatedRidesList(
                          currentAddress: viewModel.currentAddress,
                          createdRides: viewModel.createdRides,
                          potentialPassengers: viewModel.potentialPassengers,
                          onSelectRide: viewModel.selectRide,
                        ),
                  );
                } else {
                  return ActivitiesList(
                    isLoading: viewModel.isLoading,
                    activities: viewModel.activities,
                    potentialPassengers: viewModel.potentialPassengers,
                    onSelectActivity: viewModel.selectActivity,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
