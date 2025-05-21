import 'package:flutter/material.dart';

class PasswordField extends TextFormField {
  PasswordField({
    super.controller,
    required bool isVisible,
    required VoidCallback onVisibilityPressed,
  }) : super(
         decoration: InputDecoration(
           labelText: 'Password',
           prefixIcon: const Icon(Icons.lock),
           suffixIcon: IconButton(
             icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
             onPressed: onVisibilityPressed,
           ),
         ),
         obscureText: !isVisible,
       );
}
