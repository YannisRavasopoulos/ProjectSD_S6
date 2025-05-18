// lib/ui/profile/profile_field.dart
import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String       label;
  final String       value;
  final VoidCallback onEdit;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
