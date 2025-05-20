import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            // TODO
            // Handle tile press action here
          },
          child: ListTile(
            title: Text(activity.name),
            // subtitle: Text(activity.description),
            leading: IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
            ),
            trailing: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 216, 41, 29),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
