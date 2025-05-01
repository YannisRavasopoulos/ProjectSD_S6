import 'package:flutter/material.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';
import 'package:frontend/ui/login/sign_in_button.dart';
import 'package:frontend/ui/login/login_viewmodel.dart';
import 'package:frontend/ui/login/password_field.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginViewModel viewModel = LoginViewModel(
    AuthenticationService(client: http.Client()),
    UserService(client: http.Client()),
  );

  void onForgotPasswordPressed(BuildContext context) {
    // TODO
    print('Forgot password pressed');
  }

  void onSignUpPressed(BuildContext context) {
    // TODO
    print('Sign up pressed');
  }

  void onLoginPressed(BuildContext context) async {
    // TODO
    print('Login pressed');

    final success = await viewModel.login();
    if (success) {
      // Navigate to the next screen
      print('ok');
      // Navigator.pushReplacementNamed(
      //   context,
      //   '/home',
      // );
    } else {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      // Text(
                      //   viewModel.errorMessage,
                      //   style: TextStyle(color: Colors.red),
                      // ),
                      TextButton(
                        onPressed: () => onForgotPasswordPressed(context),
                        child: Text('Forgot your password?'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  SignInButton(
                    isLoading: viewModel.isLoading,
                    onPressed: () => onLoginPressed(context),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => onSignUpPressed(context),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
