import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool readOnly;

  const NameField({
    super.key,
    this.controller,
    this.labelText = 'Name',
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
}
