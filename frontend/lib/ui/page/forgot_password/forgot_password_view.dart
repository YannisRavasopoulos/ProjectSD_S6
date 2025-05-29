import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("Not Implemented Yet")),
      ),
    );
  }
}
