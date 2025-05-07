import 'package:flutter/material.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';
import 'package:frontend/ui/find_ride/find_ride_view.dart';
import 'package:frontend/ui/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/profile/profile_view.dart';
import 'package:frontend/ui/sign_in/sign_in_view.dart';
import 'package:frontend/ui/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/sign_up/sign_up_view.dart';
import 'package:frontend/ui/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/home/home_view.dart';
// Core imports
import 'package:frontend/ui/activities/activities_view.dart';
import 'package:frontend/ui/settings/settings_view.dart';
import 'package:frontend/ui/rides/rides_view.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(LoopApp());
}

// This is a simple proxy client that changes the port of the request, and https to http
class ProxyClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  ProxyClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    var uri = request.url;
    var newUri = uri.replace(port: 8000, scheme: 'http');
    var modifiedRequest = http.Request(request.method, newUri);
    modifiedRequest.headers.addAll(request.headers);
    modifiedRequest.body = request is http.Request ? request.body : "";
    return _inner.send(modifiedRequest);
  }
}

class LoopApp extends StatelessWidget {
  LoopApp({super.key});

  // TODO
  final bool isLoggedIn = true;

  SignInViewModel signInViewModel = SignInViewModel(
    AuthenticationService(client: ProxyClient()),
    UserService(client: ProxyClient()),
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
        '/forgot_password': (context) => ForgotPasswordView(),
        '/sign_up': (context) => SignUpView(viewModel: signUpViewModel),
        '/home': (context) => HomeView(),
        '/settings': (context) => SettingsView(),
        '/profile': (context) => ProfileView(),
        // Core routes
        '/activities_view': (context) => ActivitiesView(),
        '/rides_view': (context) => RidesView(),
        '/find_ride': (context) => FindRideView(),
      },
    );
  }
}
