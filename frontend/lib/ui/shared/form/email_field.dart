import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool readOnly;

  const EmailField({
    super.key,
    this.controller,
    this.labelText = 'Email',
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
