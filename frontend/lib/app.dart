// External libraries
import 'package:flutter/material.dart' hide Route;
import 'package:frontend/data/impl/impl_driver.dart';
import 'package:frontend/data/impl/impl_vehicle.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/route.dart';
import 'package:frontend/data/model/user.dart';

// Repositories
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/repository/reward_repository.dart';

// Pages
// import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_view.dart';
// import 'package:frontend/ui/page/arrange_pickup/arrange_pickup_viewmodel.dart';
// import 'package:frontend/ui/page/offer_ride/offer_ride_view.dart';
// import 'package:frontend/ui/page/offer_ride/offer_ride_viewmodel.dart';
// import 'package:frontend/ui/page/rides/rides_viewmodel.dart';
import 'package:frontend/ui/page/activities/activities_view.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:frontend/ui/page/activities/create/create_activity_view.dart';
import 'package:frontend/ui/page/activities/create/create_activity_viewmodel.dart';
import 'package:frontend/ui/page/rate/rate_view.dart';
import 'package:frontend/ui/page/forgot_password/forgot_password_view.dart';
import 'package:frontend/ui/page/ride/create/create_ride_view.dart';
import 'package:frontend/ui/page/ride/create/create_ride_viewmodel.dart';
import 'package:frontend/ui/page/ride/find/find_ride_view.dart';
import 'package:frontend/ui/page/ride/find/find_ride_viewmodel.dart';
import 'package:frontend/ui/page/home/home_view.dart';
import 'package:frontend/ui/page/home/home_viewmodel.dart';
import 'package:frontend/ui/page/rewards/rewards_view.dart';
import 'package:frontend/ui/page/rewards/rewards_viewmodel.dart';
import 'package:frontend/ui/page/profile/profile_view.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/ui/page/rate/rate_viewmodel.dart';
import 'package:frontend/ui/page/report/report_view.dart';
import 'package:frontend/ui/page/report/report_viewmodel.dart';
import 'package:frontend/ui/ride_ended/ride_ended_view.dart';
import 'package:frontend/ui/page/sign_in/sign_in_view.dart';
import 'package:frontend/ui/page/sign_in/sign_in_viewmodel.dart';
import 'package:frontend/ui/page/sign_up/sign_up_view.dart';
import 'package:frontend/ui/page/sign_up/sign_up_viewmodel.dart';
import 'package:frontend/ui/page/confirm_pickup/confirm_pickup_view.dart';
import 'package:frontend/ui/page/confirm_pickup/confirm_pickup_viewmodel.dart';
import 'package:frontend/ui/page/ride/join/join_ride_view.dart';
import 'package:frontend/ui/page/ride/join/join_ride_viewmodel.dart';

// Repository Implementations
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_rating_repository.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/impl/impl_rewards_repository.dart';
import 'package:frontend/data/impl/impl_pickup_repository.dart';
import 'package:frontend/data/impl/impl_ride_repository.dart';
import 'package:frontend/data/impl/impl_address_repository.dart';

import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/ride_ended/ride_ended_viewmodel.dart';

class App extends StatelessWidget {
  final UserRepository _userRepository = ImplUserRepository();
  final ActivityRepository _activityRepository = ImplActivityRepository();
  final RideRepository _rideRepository = ImplRideRepository();
  final RatingRepository _ratingRepository = ImplRatingRepository();
  final AddressRepository _addressRepository = ImplAddressRepository();
  late final RewardRepository _rewardRepository = RewardsRepositoryImpl(
    userRepository: _userRepository as ImplUserRepository,
  );
  late final ReportRepository _reportRepository = ImplReportRepository(
    userRepository: _userRepository as ImplUserRepository,
  );
  final PickupRepository _pickupRepository = ImplPickupRepository();

  late final FindRideViewModel findRideViewModel = FindRideViewModel(
    activityRepository: _activityRepository,
    rideRepository: _rideRepository,
    addressRepository: _addressRepository,
  );

  late final HomeViewModel homeViewModel = HomeViewModel(
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

  late final SignInViewModel signInViewModel = SignInViewModel();

  late final SignUpViewModel signUpViewModel = SignUpViewModel();

  late final ActivitiesViewModel activitiesViewModel = ActivitiesViewModel(
    activityRepository: _activityRepository,
  );

  late final CreateRideViewModel createRideViewModel = CreateRideViewModel(
    rideRepository: _rideRepository,
    activityRepository: _activityRepository,
    addressRepository: _addressRepository,
  );

  late final RideEndedViewModel rideEndedViewModel = RideEndedViewModel(
    rideRepository: _rideRepository,
    ratingRepository: _ratingRepository,
    reportRepository: _reportRepository,
    ride: Ride(
      id: 0,
      driver: ImplDriver(
        firstName: 'Ben',
        lastName: 'Dover',
        points: 0,
        id: 0,
        vehicle: ImplVehicle(id: 0, description: 'Goofy Car', capacity: 4),
      ),
      route: Route(
        start:
            Address.fake(), // Placeholder, should be replaced with actual address
        end:
            Address.fake(), // Placeholder, should be replaced with actual route
      ),
      passengers: [],
      departureTime: DateTime.now().subtract(Duration(hours: 1)),
      estimatedArrivalTime: DateTime.now(),
      estimatedDuration: Duration(hours: 1),
      totalSeats: 4,
    ),
  );

  // late final OfferRideViewModel offerRideViewModel = OfferRideViewModel(
  //   rideRepository: _rideRepository,
  // );

  // late final RidesViewModel ridesViewModel = RidesViewModel(
  //   rideRepository: _rideRepository,
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
        '/rewards': (context) => RewardView(viewModel: rewardViewModel),
        '/profile': (context) => ProfileView(viewModel: profileViewModel),
        '/ride/find': (context) => FindRideView(viewModel: findRideViewModel),
        '/ride/create':
            (context) => CreateRideView(viewModel: createRideViewModel),
        '/activities':
            (context) => ActivitiesView(viewModel: activitiesViewModel),
        '/activities/create':
            (context) => CreateActivityView(
              viewModel: CreateActivityViewModel(
                addressRepository: _addressRepository,
                activityRepository: _activityRepository,
              ),
            ),
        '/ride_ended':
            (context) => RideEndedView(viewModel: rideEndedViewModel),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/activities/edit":
            final activity = settings.arguments as Activity;
            return MaterialPageRoute(
              builder:
                  (context) => CreateActivityView(
                    viewModel: CreateActivityViewModel(
                      addressRepository: _addressRepository,
                      activityRepository: _activityRepository,
                      activity: activity,
                    ),
                  ),
            );
          case "/report":
            final reported = settings.arguments as User;
            return MaterialPageRoute(
              builder:
                  (context) => ReportView(
                    viewModel: ReportViewModel(
                      reportRepository: _reportRepository,
                      reported: reported,
                    ),
                  ),
            );
          case "/rate":
            final rated = settings.arguments as User;
            return MaterialPageRoute(
              builder:
                  (context) => RateView(
                    viewModel: RateViewModel(
                      ratingRepository: _ratingRepository,
                      userRepository: _userRepository,
                      rated: rated,
                    ),
                  ),
            );
          case "/ride/join":
            final ride = settings.arguments as Ride;
            return MaterialPageRoute(
              builder:
                  (context) => JoinRideView(
                    viewModel: JoinRideViewModel(
                      ride: ride,
                      pickupRepository: _pickupRepository,
                      rideRepository: _rideRepository,
                    ),
                  ),
            );
        }
        // if (settings.name == '/arrange_pickup') {
        //   final args = settings.arguments as Map<String, dynamic>?;

        //   if (args == null ||
        //       !args.containsKey('pickupRequest') ||
        //       !args.containsKey('driver')) {
        //     return null;
        //   }

        //   final pickupRequest = args['pickupRequest'] as PickupRequest;
        //   final driver = args['driver'] as Driver;

        //   return MaterialPageRoute(
        //     builder:
        //         (context) => ArrangePickupView(
        //           viewModel: ArrangePickupViewModel(
        //             repository: _pickupRepository,
        //             pickupRequest: pickupRequest,
        //           ),
        //         ),
        //   );
        // }

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

        //     if (settings.name == '/offer_ride') {
        //       final args = settings.arguments;
        //       Ride? ride;
        //       if (args is Map<String, dynamic> && args.containsKey('ride')) {
        //         ride = args['ride'] as Ride?;
        //       } else if (args is Ride) {
        //         ride = args;
        //       } else {
        //         ride = null;
        //       }

        //       return MaterialPageRoute(
        //         builder:
        //             (context) => OfferRideView(
        //               viewModel: OfferRideViewModel(
        //                 rideRepository: _rideRepository,
        //               ),
        //               activitiesViewModel: activitiesViewModel,
        //               // Optionally pass ride to the viewmodel if needed
        //             ),
        //       );
        //     }

        return null;
      },
    );
  }
}
