import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

import 'package:frontend/ui/arrange_pickup/arrange_pickup_viewmodel.dart';

import 'package:frontend/data/repository/rating_repository.dart';

import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/create_ride/create_ride_view.dart';
import 'package:frontend/ui/page/find_ride/find_ride_view.dart';
import 'package:frontend/ui/page/find_ride/find_ride_viewmodel.dart';
import 'package:frontend/ui/page/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/page/profile/profile_view.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/sign_in/sign_in_view.dart';
import 'package:frontend/ui/page/sign_up/sign_up_view.dart';
import 'package:frontend/ui/page/rewards/rewards_view.dart';
import 'package:frontend/ui/page/home/home_view.dart';
import 'package:frontend/ui/page/activities/activities_view.dart';
import 'package:frontend/ui/page/rides/rides_view.dart';
import 'package:frontend/ui/page/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/page/rewards/rewards_viewmodel.dart';

import 'package:frontend/ui/page/rating/rating_viewmodel.dart';

//Testing notification
import 'package:frontend/ui/arrange_pickup/arrange_pickup_view.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/service/ride_service.dart';

class App extends StatelessWidget {
  final RideRepository _rideRepository = RideRepository(
    rideService: RideService(),
  );

  final PickupRepository _pickupRepository = PickupRepository(
    pickupService: PickupService(),
  );

  final bool isLoggedIn = false;

  final UserRepository _userRepository = UserRepository();
  final RatingRepository _ratingRepository = RatingRepository();

  late final FindRideViewModel findRideViewModel = FindRideViewModel(
    rideRepository: _rideRepository,
  );

  final HomeViewModel homeViewModel = HomeViewModel(
    locationRepository: LocationRepository(),
  );

  final SignInViewModel signInViewModel = SignInViewModel(
    AuthenticationRepository(),
    UserRepository(),
  );

  final SignUpViewModel signUpViewModel = SignUpViewModel(UserRepository());

  late final ProfileViewModel profileViewModel = ProfileViewModel(
    userRepository: _userRepository,
    ratingRepository: _ratingRepository,
  )..loadUser(1); // Load user data on app start

  late final RewardViewModel rewardViewModel = RewardViewModel(
    rewardRepository: RewardRepository(),
    profileViewModel: profileViewModel,
  );
  late final RatingViewModel rateViewModel = RatingViewModel(
    ratingRepository: _ratingRepository,
  );
  final ActivitiesViewModel activitiesViewModel = ActivitiesViewModel(
    activityRepository: ActivityRepository(),
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
        '/rewards': (context) => RewardView(viewModel: rewardViewModel),
        '/sign_in': (context) => SignInView(viewModel: signInViewModel),
        '/forgot_password': (context) => ForgotPasswordView(),
        '/sign_up': (context) => SignUpView(viewModel: signUpViewModel),
        '/home': (context) => HomeView(viewModel: homeViewModel),
        '/find_ride': (context) => FindRideView(viewModel: findRideViewModel),
        '/create_ride': (context) => CreateRideView(),
        '/profile':
            (context) => ProfileView(
              viewModel: profileViewModel,
              ratingViewModel: rateViewModel,
            ),
        '/activities':
            (context) => ActivitiesView(viewModel: activitiesViewModel),
        '/rides': (context) => RidesView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/arrange_pickup') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args == null ||
              !args.containsKey('carpoolerId') ||
              !args.containsKey('driver') ||
              !args.containsKey('selectedRide')) {
            return null;
          }

          final driver = args['driver'] as Driver;
          final ride = args['selectedRide'] as Ride;

          return MaterialPageRoute(
            builder:
                (context) => ArrangePickupView(
                  viewModel: ArrangePickupViewModel(
                    repository: _pickupRepository,
                    driver: driver,
                    rideId: ride.id,
                  ),
                  carpoolerId: args['carpoolerId'] as String,
                  driver: driver,
                  selectedRide: ride,
                ),
          );
        }
        return null;
      },
    );
  }
}
