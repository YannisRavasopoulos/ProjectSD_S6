import 'package:flutter/material.dart';
import 'package:frontend/proxy_client.dart';
import 'package:frontend/ui/find_ride/find_ride_view.dart';
import 'package:frontend/ui/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/profile/profile_view.dart';
import 'package:frontend/ui/sign_in/sign_in_view.dart';
import 'package:frontend/ui/sign_up/sign_up_view.dart';
import 'package:frontend/ui/home/home_view.dart';
import 'package:frontend/ui/activities/activities_view.dart';
import 'package:frontend/ui/settings/settings_view.dart';
import 'package:frontend/ui/rides/rides_view.dart';
import 'package:frontend/ui/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';

class App extends StatelessWidget {
  App({super.key});

  // TODO
  final bool isLoggedIn = true;

  final SignInViewModel signInViewModel = SignInViewModel(
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
