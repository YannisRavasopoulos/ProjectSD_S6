import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/activities/activity_card.dart';
import 'package:frontend/ui/page/activities/activity_deletion_dialog.dart';
import 'package:frontend/ui/page/activities/create_activity_view.dart';
import 'package:frontend/ui/shared/nav/app_navigation_bar.dart';

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({super.key, required this.viewModel});

  final ActivitiesViewModel viewModel;

  void _onRemoveActivityPressed(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ActivityDeletionDialog(
          activityName: activity.name,
          onDelete: () {
            viewModel.deleteActivity(activity);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Activity "${activity.name}" deleted')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.activities == null ||
              viewModel.activities!.isEmpty) {
            return const Center(child: Text('No activities found'));
          } else {
            return _buildActivityList(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateActivityView(
                viewModel: viewModel,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/activities"),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.activities?.length ?? 0,
      itemBuilder: (context, index) {
        final activity = viewModel.activities![index];
        return ActivityCard(
          activity: activity,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateActivityView(
                  viewModel: viewModel,
                  activityToEdit: activity,
                ),
              ),
            );
          },
          onRemove: () => _onRemoveActivityPressed(context, activity),
        );
      },
    );
  }
}
