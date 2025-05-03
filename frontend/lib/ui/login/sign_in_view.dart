import 'package:flutter/material.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';
import 'package:frontend/ui/login/loading_button.dart';
import 'package:frontend/ui/login/sign_in_viewmodel.dart';
import 'package:frontend/ui/login/password_field.dart';
import 'package:frontend/ui/login/wrapper.dart';
import 'package:http/http.dart' as http;

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final SignInViewModel viewModel = SignInViewModel(
    AuthenticationService(client: http.Client()),
    UserService(client: http.Client()),
  );

  void _onForgotPasswordPressed(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }

  void _onSignUpPressed(BuildContext context) {
    Navigator.pushNamed(context, '/sign-up');
  }

  void _onLoginPressed(BuildContext context) async {
    final success = await viewModel.login();
    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Hide the current snackbar if it exists
      var messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(viewModel.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrapper(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: viewModel.emailController,
                ),
                SizedBox(height: 16),
                PasswordField(controller: viewModel.passwordController),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _onForgotPasswordPressed(context),
                      child: Text('Forgot your password?'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: LoadingButton(
                    isLoading: viewModel.isLoading,
                    onPressed: () => _onLoginPressed(context),
                    child: Text('Sign In'),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => _onSignUpPressed(context),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
