import 'package:flutter/material.dart';

class RideDeletionDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const RideDeletionDialog({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Ride'),
      content: const Text('Are you sure you want to delete this ride?'),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        TextButton(
          onPressed: onDelete,
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
