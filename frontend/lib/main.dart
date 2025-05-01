import 'package:flutter/material.dart';
import 'package:frontend/ui/login_view.dart';

void main() {
  runApp(const LoopApp());
}

class LoopApp extends StatelessWidget {
  const LoopApp({super.key});

  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Loop App', home: LoginView());
  }
}
