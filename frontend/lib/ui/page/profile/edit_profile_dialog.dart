// lib/ui/profile/edit_profile_dialog.dart
import 'package:flutter/material.dart';

class EditProfileDialog extends StatelessWidget {
  final String            fieldName;
  final String            currentValue;
  final ValueChanged<String> onSave;
  final bool              obscure;

  const EditProfileDialog({
    Key? key,
    required this.fieldName,
    required this.currentValue,
    required this.onSave,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: currentValue);

    return AlertDialog(
      title: Text('Edit $fieldName'),
      content: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(hintText: fieldName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
