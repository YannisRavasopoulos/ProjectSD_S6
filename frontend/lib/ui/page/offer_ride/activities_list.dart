import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/passenger.dart';
import 'package:frontend/ui/page/offer_ride/activity_list_card.dart';
import 'package:frontend/ui/page/offer_ride/carpooler_selection_sheet.dart';

class ActivitiesList extends StatelessWidget {
  final bool isLoading;
  final List<Activity> activities;
  final List<Passenger> potentialPassengers;
  final Future<void> Function(Activity) onSelectActivity;

  const ActivitiesList({
    super.key,
    required this.isLoading,
    required this.activities,
    required this.potentialPassengers,
    required this.onSelectActivity,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (activities.isEmpty) {
      return const Center(child: Text('No activities found'));
    }
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ActivityListCard(
          activity: activity,
          onCarpoolTap: () async {
            await onSelectActivity(activity);
            showModalBottomSheet(
              context: context,
              builder:
                  (_) => CarpoolerSelectionSheet(
                    carpoolers: potentialPassengers,
                    activity: activity,
                  ),
            );
          },
        );
      },
    );
  }
}
