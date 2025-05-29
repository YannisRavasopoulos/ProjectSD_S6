import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/activities/activity_card.dart';
import 'package:frontend/ui/page/activities/activity_deletion_dialog.dart';
import 'package:frontend/ui/shared/nav/app_navigation_bar.dart';

class ActivitiesView extends StatelessWidget {
  final ActivitiesViewModel viewModel;

  const ActivitiesView({super.key, required this.viewModel});

  void _onDeleteActivityConfirmPressed(
    BuildContext context,
    Activity activity,
  ) {
    viewModel.deleteActivity(activity);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activity "${activity.name}" deleted')),
    );
  }

  void _onCreateActivityPressed(BuildContext context) {
    Navigator.pushNamed(context, '/activities/create');
  }

  void _onEditActivityPressed(BuildContext context, Activity activity) {
    Navigator.pushNamed(context, '/activities/edit', arguments: activity);
  }

  void _onDeleteActivityPressed(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ActivityDeletionDialog(
          activityName: activity.name,
          onConfirm: () => _onDeleteActivityConfirmPressed(context, activity),
          onCancel: () => Navigator.pop(context),
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
          } else if (viewModel.activities.isEmpty) {
            return const Center(child: Text('No activities found'));
          } else {
            return _buildActivityList(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onCreateActivityPressed(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppNavigationBar(routeName: "/activities"),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.activities.length,
      itemBuilder: (context, index) {
        final activity = viewModel.activities[index];
        return ActivityCard(
          activity: activity,
          onEdit: () => _onEditActivityPressed(context, activity),
          onRemove: () => _onDeleteActivityPressed(context, activity),
        );
      },
    );
  }
}
