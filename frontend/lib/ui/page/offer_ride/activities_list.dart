import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/ui/page/offer_ride/activity_list_card.dart';
import 'package:frontend/ui/page/offer_ride/carpooler_selection_sheet.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';

class ActivitiesList extends StatelessWidget {
  final ActivitiesViewModel viewModel;
  final OfferRideViewModel offerRideViewModel;

  const ActivitiesList({
    super.key,
    required this.viewModel,
    required this.offerRideViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final activities = viewModel.activities;
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (activities == null || activities.isEmpty) {
          return const Center(child: Text('No activities found'));
        }
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index] as ImplActivity;
            return ActivityListCard(
              activity: activity,
              onCarpoolTap: () async {
                await offerRideViewModel.selectActivity(activity);
                showModalBottomSheet(
                  context: context,
                  builder: (_) => CarpoolerSelectionSheet(
                    carpoolers: offerRideViewModel.potentialPassengers,
                    activity: activity,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
