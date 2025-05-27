// External libraries
import 'package:flutter/material.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/passenger.dart';

// Repositories
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/repository/reward_repository.dart';

// Pages
import 'package:frontend/ui/page/activities/activities_view.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_view.dart';
import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_viewmodel.dart';
import 'package:frontend/ui/page/create_ride/create_ride_view.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_view.dart';
import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';
import 'package:frontend/ui/page/rate/rate_view.dart';
import 'package:frontend/ui/page/find_ride/find_ride_view.dart';
import 'package:frontend/ui/page/find_ride/find_ride_viewmodel.dart';
import 'package:frontend/ui/page/home/home_view.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/page/rewards/rewards_view.dart';
import 'package:frontend/ui/page/rewards/rewards_viewmodel.dart';
import 'package:frontend/ui/page/profile/profile_view.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/rate/rate_viewmodel.dart';
import 'package:frontend/ui/page/report/report_view.dart';
import 'package:frontend/ui/page/report/report_viewmodel.dart';
import 'package:frontend/ui/page/rides/rides_viewmodel.dart';
import 'package:frontend/ui/page/sign_in/sign_in_view.dart';
import 'package:frontend/ui/page/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/page/sign_up/sign_up_view.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/page/confirm_pickup/confirm_pickup_view.dart';
import 'package:frontend/ui/page/confirm_pickup/confirm_pickup_viewmodel.dart';
import 'package:frontend/ui/page/join_ride/join_ride_view.dart';
import 'package:frontend/ui/page/join_ride/join_ride_viewmodel.dart';

// Repository Implementations
import 'package:frontend/data/impl/address_repository_impl.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_rating_repository.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/impl/impl_rewards_repository.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';

// Mocks
import 'package:frontend/data/mocks/mock_location_repository.dart';
import 'package:frontend/data/mocks/mock_authentication_repository.dart';

import 'package:frontend/data/model/driver.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/ride.dart';

class App extends StatelessWidget {
  // Replace mocks with implementations
  final UserRepository _userRepository = ImplUserRepository();
  final ActivityRepository _activityRepository = ImplActivityRepository();
  final RideRepository _rideRepository = ImplRideRepository();
  final RatingRepository _ratingRepository = ImplRatingRepository();
  final LocationRepository _locationRepository = MockLocationRepository();
  late final RewardRepository _rewardRepository = RewardsRepositoryImpl(
    userRepository: _userRepository as ImplUserRepository,
  );
  final AuthenticationRepository _authenticationRepository =
      MockAuthenticationRepository();
  final AddressRepository _addressRepository = AddressRepositoryImpl();
  late final ReportRepository _reportRepository = ImplReportRepository(
    userRepository: _userRepository as ImplUserRepository,
  );
  final PickupRepository _pickupRepository = ImplPickupRepository();
  late final FindRideViewModel findRideViewModel = FindRideViewModel(
    rideRepository: _rideRepository,
  );

  late final HomeViewModel homeViewModel = HomeViewModel(
    userRepository: _userRepository,
    locationRepository: _locationRepository,
    addressRepository: _addressRepository,
  );

  late final ProfileViewModel profileViewModel = ProfileViewModel(
    userRepository: _userRepository,
    ratingRepository: _ratingRepository,
    rideRepository: _rideRepository,
  );

  late final RewardViewModel rewardViewModel = RewardViewModel(
    rewardRepository: _rewardRepository,
    userRepository: _userRepository,
  );

  late final RateViewModel rateViewModel = RateViewModel(
    ratingRepository: _ratingRepository,
    userRepository: _userRepository,
  );

  late final CreateRideViewModel createRideViewModel = CreateRideViewModel(
    rideRepository: _rideRepository,
  );

  late final SignInViewModel signInViewModel = SignInViewModel(
    _authenticationRepository,
    _userRepository,
  );

  late final SignUpViewModel signUpViewModel = SignUpViewModel(
    userRepository: _userRepository,
  );

  late final ActivitiesViewModel activitiesViewModel = ActivitiesViewModel(
    activityRepository: _activityRepository,
  );

  late final ReportViewModel reportViewModel = ReportViewModel(
    reportRepository: _reportRepository,
  );

  late final OfferRideViewModel offerRideViewModel = OfferRideViewModel(
    rideRepository: _rideRepository,
  );

  late final RidesViewModel ridesViewModel = RidesViewModel(
    rideRepository: _rideRepository,
  );

  // final AuthenticationRepository _authenticationRepository =
  //     AuthenticationRepository();
  // final ActivityRepository _activityRepository = ActivityRepository();
  // final ReportRepository _reportRepository = ReportRepository();

  // late final RidesListViewModel ridesViewModel = RidesListViewModel(
  //   rideRepository: _rides,
  // );

  final bool isLoggedIn = true;

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
        '/sign_up': (context) => SignUpView(viewModel: signUpViewModel),
        '/forgot_password': (context) => ForgotPasswordView(),
        '/home': (context) => HomeView(viewModel: homeViewModel),
        '/find_ride': (context) => FindRideView(viewModel: findRideViewModel),
        '/rate':
            (context) => RateView(
              toUser: ImplUser(
                firstName: 'John',
                lastName: 'Doe',
                points: 0,
                id: 0,
              ),
              viewModel: rateViewModel,
            ),
        '/rewards': (context) => RewardView(viewModel: rewardViewModel),
        '/profile': (context) => ProfileView(viewModel: profileViewModel),
        '/activities':
            (context) => ActivitiesView(viewModel: activitiesViewModel),
        '/report': (context) => ReportView(viewModel: reportViewModel),
        '/create_ride': (context) => CreateRideView(
              viewModel: createRideViewModel,
              ridesViewModel: ridesViewModel,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/arrange_pickup') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args == null ||
              !args.containsKey('pickupRequest') ||
              !args.containsKey('driver') ||
              !args.containsKey('rideId')) {
            return null;
          }

          final pickupRequest = args['pickupRequest'] as PickupRequest;
          final driver = args['driver'] as Driver;
          final rideId = args['rideId'] as int;

          return MaterialPageRoute(
            builder:
                (context) => ArrangePickupView(
                  viewModel: ArrangePickupViewModel(
                    repository: _pickupRepository,
                    pickupRequest: pickupRequest,
                  ),
                ),
          );
        }

        if (settings.name == '/confirm_pickup') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args == null || !args.containsKey('pickup')) {
            return null;
          }

          final pickup = args['pickup'] as Pickup;

          return MaterialPageRoute(
            builder:
                (context) => ConfirmPickupView(
                  pickup: pickup,
                  viewModel: ConfirmPickupViewModel(
                    pickupRepository: _pickupRepository,
                    pickup: pickup,
                  ),
                ),
          );
        }

        if (settings.name == '/join_ride') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey('ride')) {
            return null;
          }
          final ride = args['ride'] as Ride;

          return MaterialPageRoute(
            builder:
                (context) => JoinRideView(
                  viewModel: JoinRideViewModel(
                    ride: ride,
                    pickupRepository: _pickupRepository,
                  ),
                ),
          );
        }

        if (settings.name == '/offer_ride') {
          final args = settings.arguments;
          Ride? ride;
          if (args is Map<String, dynamic> && args.containsKey('ride')) {
            ride = args['ride'] as Ride?;
          } else if (args is Ride) {
            ride = args;
          } else {
            ride = null;
          }

          return MaterialPageRoute(
            builder: (context) => OfferRideView(
              viewModel: OfferRideViewModel(rideRepository: _rideRepository),
              activitiesViewModel: activitiesViewModel,
              // Optionally pass ride to the viewmodel if needed
            ),
          );
        }

        return null;
      },
    );
  }
}
