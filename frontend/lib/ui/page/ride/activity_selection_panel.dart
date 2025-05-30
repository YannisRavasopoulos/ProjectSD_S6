import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';

class ActivitySelectionPanel extends StatelessWidget {
  final List<Activity> activities;
  final ValueChanged<Activity> onActivitySelected;

  const ActivitySelectionPanel({
    super.key,
    required this.onActivitySelected,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose an Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (activities.isEmpty) const Text('No activities available.'),
          ...activities.map(
            (activity) => ListTile(
              leading: const Icon(Icons.event),
              title: Text(activity.name),
              subtitle: Text(activity.description),
              onTap: () {
                onActivitySelected(activity);
              },
            ),
          ),
        ],
      ),
    );
  }
}
