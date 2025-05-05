import 'package:flutter/material.dart';
import 'package:frontend/ui/loading_button.dart';
import 'package:frontend/ui/sign_up/sign_up_viewmodel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key, required SignUpViewModel viewModel})
    : _viewModel = viewModel;

  final SignUpViewModel _viewModel;

  void _onPasswordVisiblePressed(BuildContext context) {
    _viewModel.togglePasswordVisibility();
  }

  void _onConfirmPasswordVisiblePressed(BuildContext context) {
    _viewModel.toggleConfirmPasswordVisibility();
  }

  void _onSignUpPressed(BuildContext context) {
    _viewModel.signUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: _viewModel,
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
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _viewModel.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _viewModel.passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => _onPasswordVisiblePressed(context),
                      ),
                    ),
                    obscureText: !_viewModel.passwordVisible,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _viewModel.confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _viewModel.confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () => _onConfirmPasswordVisiblePressed(context),
                      ),
                    ),
                    obscureText: !_viewModel.confirmPasswordVisible,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _viewModel.doPasswordsMatch ? '' : 'Passwords do not match',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  LoadingButton(
                    onPressed: () => _onSignUpPressed(context),
                    isLoading: _viewModel.isLoading,
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
