import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/page/offer_ride/activities_list.dart';
import 'package:frontend/ui/page/offer_ride/created_ride_list.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_mode_selector.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';

enum OfferRideMode { createdRides, activities }

class OfferRideView extends StatelessWidget {
  final OfferRideViewModel viewModel;
  final ActivitiesViewModel activitiesViewModel;

  const OfferRideView({
    super.key,
    required this.viewModel,
    required this.activitiesViewModel,
  });

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
                          isLoading: viewModel.isLoading,
                          createdRides: viewModel.createdRides,
                          potentialPassengers: viewModel.potentialPassengers,
                          onSelectRide: viewModel.selectRide,
                        ),
                  );
                } else {
                  return ActivitiesList(
                    isLoading: viewModel.areActivitiesLoading,
                    activities: viewModel.activities,
                    potentialPassengers: viewModel.potentialPassengers,
                    onSelectActivity: viewModel.selectActivity,
                  ),
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
