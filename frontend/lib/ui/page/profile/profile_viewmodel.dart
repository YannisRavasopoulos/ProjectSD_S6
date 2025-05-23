import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final RatingRepository ratingRepository;
  final UserRepository userRepository;
  final RideRepository rideRepository;

  ProfileViewModel({
    required this.ratingRepository,
    required this.userRepository,
    required this.rideRepository,
  }) {
    _init();
  }

  void _init() async {
    var user = await userRepository.fetchCurrent();
    var history = await rideRepository.fetchHistory();
    var ratings = await ratingRepository.fetch(user);

    _onUserUpdate(user);
    _onRatingsUpdate(ratings);
    _onHistoryUpdate(history);

    _userSubscription = userRepository.watchCurrent().listen(_onUserUpdate);
    _ratingSubscription = ratingRepository.watch(user).listen(_onRatingsUpdate);
    _historySubscription = rideRepository.watchHistory().listen(
      _onHistoryUpdate,
    );

    isLoading = false;
    notifyListeners();
  }

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<List<Rating>> _ratingSubscription;
  late final StreamSubscription<List<Ride>> _historySubscription;

  void _onHistoryUpdate(List<Ride> rides) {
    this.rides = rides;
    notifyListeners();
  }

  void _onUserUpdate(User user) {
    firstName = user.firstName;
    lastName = user.lastName;
    points = user.points;
    notifyListeners();
  }

  void _onRatingsUpdate(List<Rating> ratings) {
    this.ratings = ratings;
    averageRating =
        ratings.fold(0, (sum, rating) => sum + rating.stars) / ratings.length;
    notifyListeners();
  }

  // State
  bool isLoading = true;
  List<Ride> rides = [];
  List<Rating> ratings = [];
  double averageRating = 0;
  bool isEditing = false;
  int points = 0;

  // Subject to change
  String firstName = '';
  String lastName = '';

  // TODO these should be updated from the repository somehow
  String email = 'mail';
  String password = 'perfectpassword';

  void clearHistory() async {
    notifyListeners();
    await rideRepository.clearHistory();
  }

  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void onFirstNameChanged(String value) {
    firstName = value;
    notifyListeners();
  }

  void onLastNameChanged(String value) {
    lastName = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    password = value;
    notifyListeners();
  }

  void saveChanges() {
    // TODO: Save changes logic here
    isEditing = false;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    email = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _ratingSubscription.cancel();
    _userSubscription.cancel();
    _historySubscription.cancel();
    super.dispose();
  }
}
