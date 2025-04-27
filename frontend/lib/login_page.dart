import 'package:flutter/material.dart';
import 'package:frontend/password_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const TextField(
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
                ),
              ),
              const SizedBox(height: 16),
              const PasswordField(),
              SizedBox(height: 4),
              Text('Forgot your password?'),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: login logic
                  print('Log In');
                },
                child: const Text('Log In'),
              ),
              SizedBox(height: 16),
              Text(
                "Don't have an account? Sign Up",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
