import 'package:flutter/material.dart';

class ActivityDeletionDialog extends AlertDialog {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ActivityDeletionDialog({
    super.key,
    required String activityName,
    required this.onConfirm,
    required this.onCancel,
  }) : super(
         title: const Text('Are you sure?'),
         content: Text(
           'Do you really want to delete the activity "$activityName"?',
         ),
         actions: [
           TextButton(onPressed: onConfirm, child: const Text('Confirm')),
           TextButton(onPressed: onCancel, child: const Text('Cancel')),
         ],
       );
}
