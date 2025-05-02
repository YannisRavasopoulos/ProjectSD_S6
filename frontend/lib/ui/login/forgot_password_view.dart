import 'package:flutter/material.dart';
import 'package:frontend/ui/login/wrapper.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Wrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your email address to reset your password',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle password reset logic here
              },
              child: const Text('Send Reset Link'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the login screen
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
