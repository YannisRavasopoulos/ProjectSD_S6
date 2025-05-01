import 'package:flutter/material.dart';
import 'package:frontend/ui/password_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
              const TextField(decoration: InputDecoration(labelText: 'Email')),
              const SizedBox(height: 16),
              const PasswordField(),
              SizedBox(height: 4),
              Text('Forgot your password?'),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  // TODO: login logic
                  print('Log In');
                  // UserModel.login()
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
