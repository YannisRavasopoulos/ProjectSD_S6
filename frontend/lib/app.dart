import 'package:flutter/material.dart';
import 'package:frontend/data/impl/address_repository_impl.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_rating_repository.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/mocks/mock_authentication_repository.dart';
import 'package:frontend/data/impl/impl_rewards_repository.dart';
import 'package:frontend/data/mocks/mock_authentication_repository.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/ui/page/activities/activities_view.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/create_ride/create_ride_view.dart';
import 'package:frontend/ui/page/create_ride/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/page/rate/rate_view.dart';
import 'package:frontend/data/mocks/mock_location_repository.dart';
import 'package:frontend/data/mocks/mock_rating_repository.dart';
import 'package:frontend/data/mocks/mock_ride_repository.dart';
import 'package:frontend/data/mocks/mock_user_repository.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
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
import 'package:frontend/ui/page/rewards/rewards_view.dart';
import 'package:frontend/ui/page/rewards/rewards_viewmodel.dart';
import 'package:frontend/ui/page/sign_in/sign_in_view.dart';
import 'package:frontend/ui/page/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/page/sign_up/sign_up_view.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/data/repository/authentication_repository.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/repository/location_repository.dart';
import 'package:frontend/data/mocks/mock_reward_repository.dart';
import 'package:frontend/data/mocks/mock_authentication_repository.dart';
import 'package:frontend/data/mocks/mock_location_repository.dart';
import 'package:frontend/data/mocks/mock_rating_repository.dart';
import 'package:frontend/data/mocks/mock_ride_repository.dart';
import 'package:frontend/data/mocks/mock_user_repository.dart';
import 'package:geocode/geocode.dart';


class App extends StatelessWidget {
  // Replace mocks with implementations
  final UserRepository _userRepository = ImplUserRepository();
  final ActivityRepository _activityRepository = ImplActivityRepository();
  final RatingRepository _ratingRepository = ImplRatingRepository();
  final RideRepository _rideRepository = MockRideRepository();
  final LocationRepository _locationRepository = MockLocationRepository();
  final RewardRepository _rewardRepository = RewardsRepositoryImpl();
  final AuthenticationRepository _authenticationRepository =
      MockAuthenticationRepository();
  final AddressRepository _addressRepository = AddressRepositoryImpl();
  final ReportRepository _reportRepository = ImplReportRepository();

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

  // late final OfferRideViewModel offerRideViewModel = OfferRideViewModel(
  //   rideRepository: _rideRepository,
  //   userRepository: _userRepository,
  // );

  // final PickupRepository _pickupRepository = PickupRepository(
  //   pickupService: PickupService(),
  // );
  // final AuthenticationRepository _authenticationRepository =
  //     AuthenticationRepository();
  // final ActivityRepository _activityRepository = ActivityRepository();
  // final ReportRepository _reportRepository = ReportRepository();

  // late final RidesListViewModel ridesViewModel = RidesListViewModel(
  //   rideRepository: _rides,
  // );

  // late final RatingViewModel rateViewModel = RatingViewModel(
  //   ratingRepository: _ratingRepository,
  // );

  late final ActivitiesViewModel activitiesViewModel = ActivitiesViewModel(
    activityRepository: _activityRepository,
  );

  late final ReportViewModel reportViewModel = ReportViewModel(
    reportRepository: _reportRepository,
  );

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
              toUser: ImplUser(firstName: 'John', lastName: 'Doe', points: 0, id: 0),
              viewModel: rateViewModel,
            ),
        '/create_ride':
            (context) => CreateRideView(viewModel: createRideViewModel),
        '/rewards': (context) => RewardView(viewModel: rewardViewModel),
        '/profile': (context) => ProfileView(viewModel: profileViewModel),
        '/activities':
            (context) => ActivitiesView(viewModel: activitiesViewModel),
        // '/rides':
        //     (context) => RidesView(
        //       viewModel: ridesViewModel,
        //       createRideViewModel: createRideViewModel,
        //     ),
        // '/offer_ride':
        //     (context) => OfferRideView(
        //       viewModel: offerRideViewModel,
        //       activitiesViewModel: activitiesViewModel,
        //     ),
        '/report': (context) => ReportView(viewModel: reportViewModel),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/arrange_pickup') {
      //     final args = settings.arguments as Map<String, dynamic>?;

      //     if (args == null ||
      //         !args.containsKey('carpoolerId') ||
      //         !args.containsKey('driver') ||
      //         !args.containsKey('selectedRide')) {
      //       return null;
      //     }

      //     final driver = args['driver'] as Driver;
      //     final ride = args['selectedRide'] as Ride;

      //     return MaterialPageRoute(
      //       builder:
      //           (context) => ArrangePickupView(
      //             viewModel: ArrangePickupViewModel(
      //               repository: _pickupRepository,
      //               driver: driver,
      //               rideId: ride.id,
      //             ),
      //             carpoolerId: args['carpoolerId'] as String,
      //             driver: driver,
      //             selectedRide: ride,
      //           ),
      //     );
      //   }
      //   return null;
      // },
    );
  }
}
