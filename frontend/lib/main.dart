import 'package:flutter/material.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';
import 'package:frontend/ui/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/sign_in/sign_in_view.dart';
import 'package:frontend/ui/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/sign_up/sign_up_view.dart';
import 'package:frontend/ui/sign_up/sign_up_viewmodel.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(LoopApp());
}

class LoopApp extends StatelessWidget {
  LoopApp({super.key});

  // TODO
  final bool isLoggedIn = false;

  final SignInViewModel signInViewModel = SignInViewModel(
    AuthenticationService(client: http.Client()),
    UserService(client: http.Client()),
  );

  final SignUpViewModel signUpViewModel = SignUpViewModel(
    userService: UserService(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.comfortable,
      ),
      initialRoute: isLoggedIn ? '/home' : '/sign_in',
      routes: {
        '/sign_in': (context) => SignInView(viewModel: signInViewModel),
        // '/home': (context) => HomeView(),
        '/forgot_password': (context) => ForgotPasswordView(),
        '/sign_up': (context) => SignUpView(viewModel: signUpViewModel),
      },
    );
  }
}
