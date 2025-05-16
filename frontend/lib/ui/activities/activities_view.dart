import 'package:flutter/material.dart';
import 'package:frontend/ui/activities/activities_viewmodel.dart';
import 'package:frontend/ui/activities/activity_card.dart';

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ActivitiesViewModel();

    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: ListView.builder(
        itemCount: viewModel.activities.length,
        itemBuilder: (context, index) {
          final activity = viewModel.activities[index];
          return ActivityCard(
            activity: activity,
            onEdit: () {
              // Navigate to an edit screen or show a dialog
              print('Edit activity: ${activity.name}');
            },
            onDelete: () {
              print('Delete activity: ${activity.name}');
            },
          );
        },
      ),
    );
  }
}
