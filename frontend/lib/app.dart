import 'package:flutter/material.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/ui/create_ride/create_ride_view.dart';
import 'package:frontend/ui/find_ride/find_ride_view.dart';
import 'package:frontend/ui/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/profile/profile_view.dart';
import 'package:frontend/ui/sign_in/sign_in_view.dart';
import 'package:frontend/ui/sign_up/sign_up_view.dart';
import 'package:frontend/ui/rewards/rewards_view.dart';
import 'package:frontend/ui/home/home_view.dart';
import 'package:frontend/ui/activities/activities_view.dart';
import 'package:frontend/ui/settings/settings_view.dart';
import 'package:frontend/ui/rides/rides_view.dart';
import 'package:frontend/ui/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/data/service/authentication_service.dart';
import 'package:frontend/data/service/user_service.dart';
import 'package:frontend/ui/rewards/rewards_viewmodel.dart';
import 'package:frontend/ui/arrange_pickup/arrange_pickup_view.dart';

class App extends StatelessWidget {
  App({super.key});

  bool isLoggedIn = false;

  final SignInViewModel signInViewModel = SignInViewModel(
    AuthenticationRepository(),
    UserRepository(),
  );

  final SignUpViewModel signUpViewModel = SignUpViewModel(UserRepository());

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
        '/rewards': (context) => RewardView(viewModel: RewardViewModel()),
        '/sign_in': (context) => SignInView(viewModel: signInViewModel),
        '/forgot_password': (context) => ForgotPasswordView(),
        '/sign_up': (context) => SignUpView(viewModel: signUpViewModel),
        '/home': (context) => HomeView(),
        '/find_ride': (context) => FindRideView(),
        '/create_ride': (context) => CreateRideView(),
        '/profile': (context) => ProfileView(),
        '/settings': (context) => SettingsView(),
        '/activities': (context) => ActivitiesView(),
        '/rides': (context) => RidesView(),
        '/arrange_pickup':
            (context) => ArrangePickupView(
              carpoolerId: "test_carpooler_id",
              driverId: "test_driver_id",
            ),
      },
    );
  }
}
