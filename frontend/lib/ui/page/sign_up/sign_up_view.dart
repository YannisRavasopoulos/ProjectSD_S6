import 'package:flutter/material.dart';
import 'package:frontend/ui/loading_button.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/shared/form/email_field.dart';
import 'package:frontend/ui/shared/form/name_field.dart';
import 'package:frontend/ui/shared/form/password_field.dart';
import 'package:frontend/ui/shared/form/confirm_password_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key, required this.viewModel});

  final SignUpViewModel viewModel;

  void _onPasswordVisiblePressed() {
    viewModel.togglePasswordVisibility();
  }

  void _onConfirmPasswordVisiblePressed() {
    viewModel.toggleConfirmPasswordVisibility();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  EmailField(controller: viewModel.emailController),
                  const SizedBox(height: 16),
                  NameField(controller: viewModel.nameController),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: viewModel.passwordController,
                    isVisible: viewModel.isPasswordVisible,
                    onVisibilityPressed: _onPasswordVisiblePressed,
                  ),
                  const SizedBox(height: 16),
                  ConfirmPasswordField(
                    controller: viewModel.confirmPasswordController,
                    isVisible: viewModel.isConfirmPasswordVisible,
                    onVisibilityPressed: _onConfirmPasswordVisiblePressed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.doPasswordsMatch ? '' : 'Passwords do not match',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  LoadingButton(
                    onPressed: () => _onSignUpPressed(context),
                    isLoading: viewModel.isLoading,
                    child: const Text('Sign Up'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
