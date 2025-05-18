import 'package:flutter/material.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/activities/activity_card.dart';
import 'package:frontend/ui/page/activities/activity_deletion_dialog.dart';
import 'package:frontend/ui/page/create_activity/create_activity_view.dart';
import 'package:frontend/ui/shared/bottom_panel.dart';

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
            onRemove: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ActivityDeletionDialog(
                    activityName: activity.name,
                    onDelete: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Activity "${activity.name}" deleted'),
                        ),
                      );
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CreateActivityView(
                    onCreate: (newActivity) {
                      // viewModel.addActivity(newActivity);
                    },
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomPanel(routeName: "/activities"),
    );
  }
}
