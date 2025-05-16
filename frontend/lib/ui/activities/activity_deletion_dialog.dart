import 'package:flutter/material.dart';

class ActivityDeletionDialog extends AlertDialog {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  ActivityDeletionDialog({
    super.key,
    required String activityName,
    required this.onDelete,
    required this.onCancel,
  }) : super(
         title: const Text('Are you sure?'),
         content: Text(
           'Do you really want to delete the activity "$activityName"?',
         ),
         actions: [
           TextButton(onPressed: onCancel, child: const Text('Cancel')),
           TextButton(onPressed: onDelete, child: const Text('Delete')),
         ],
       );
}
