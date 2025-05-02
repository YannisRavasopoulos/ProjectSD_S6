import 'package:flutter/material.dart';
import 'package:frontend/ui/login/forgot_password_view.dart';
import 'package:frontend/ui/login/login_view.dart';

void main() {
  runApp(const LoopApp());
}

class LoopApp extends StatelessWidget {
  const LoopApp({super.key});

  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.comfortable,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginView(),
        // '/home': (context) => HomeView(),
        '/forgot-password': (context) => ForgotPasswordView(),
        // '/sign-up': (context) => SignUpView(),
      },
    );
  }
}
