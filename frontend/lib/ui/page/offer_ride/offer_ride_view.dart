import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/page/offer_ride/activities_list.dart';
import 'package:frontend/ui/page/offer_ride/created_ride_list.dart';
import 'package:frontend/ui/page/offer_ride/offerRideModeSelector.dart';
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
    final Ride? newRide = ModalRoute.of(context)?.settings.arguments as Ride?;
    if (newRide != null &&
        !viewModel.createdRides.any((r) => r.id == newRide.id)) {
      viewModel.addRide(newRide);
    }

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
                  return CreatedRidesList(viewModel: viewModel);
                } else {
                  return ActivitiesList(
                    viewModel: activitiesViewModel,
                    fetchCarpoolers: viewModel.findNearbyCarpoolers,
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
