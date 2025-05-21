import 'package:flutter/material.dart';

class NameField extends TextFormField {
  NameField({super.key, super.controller})
    : super(
        decoration: const InputDecoration(
          labelText: 'Name',
          prefixIcon: Icon(Icons.person),
        ),
      );
}
