import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/loading_button.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/shared/form/email_field.dart';
import 'package:frontend/ui/shared/form/name_field.dart';
import 'package:frontend/ui/shared/form/password_field.dart';

import 'package:frontend/ui/view.dart';

class SignUpView extends ViewBase<SignUpViewModel> {
  const SignUpView({super.key, required super.viewModel});

  void _onSignUpPressed(BuildContext context) async {
    final success = await viewModel.signUp();

    if (!success) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(viewModel.errorMessage)));
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 32),
              EmailField(controller: viewModel.emailController),
              Text(
                viewModel.isEmailValid
                    ? ''
                    : 'Please enter a valid email address',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 8),
              NameField(controller: viewModel.nameController),
              Text(
                viewModel.isNameValid ? '' : 'Please enter your full name',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 8),
              PasswordField(controller: viewModel.passwordController),
              Text(
                viewModel.isPasswordValid
                    ? ''
                    : 'Password must be at least 8 characters long',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 8),
              PasswordField(
                labelText: 'Confirm Password',
                controller: viewModel.confirmPasswordController,
              ),
              SizedBox(height: 8),
              Text(
                viewModel.doPasswordsMatch ? '' : 'Passwords do not match',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: LoadingButton(
                    onPressed:
                        viewModel.canSignUp
                            ? () => _onSignUpPressed(context)
                            : null,
                    isLoading: viewModel.isLoading,
                    child: Text('Sign Up'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
