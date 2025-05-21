import 'package:flutter/material.dart';

class EmailField extends TextFormField {
  EmailField({super.key, super.controller})
    : super(
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
      );
}
