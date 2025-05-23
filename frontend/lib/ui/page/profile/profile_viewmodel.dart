import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required this.ratingRepository,
    required this.userRepository,
  }) {
    init();
  }

  void init() async {
    var user = await userRepository.fetchCurrent();
    var ratings = await ratingRepository.fetch(user);

    onUserUpdate(user);
    onRatingsUpdate(ratings);

    _userSubscription = userRepository.watchCurrent().listen(onUserUpdate);
    _ratingSubscription = ratingRepository.watch(user).listen(onRatingsUpdate);

    isLoading = false;
    notifyListeners();
  }

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<List<Rating>> _ratingSubscription;

  void onUserUpdate(User user) {
    firstName = user.firstName;
    lastName = user.lastName;
    notifyListeners();
  }

  void onRatingsUpdate(List<Rating> ratings) {
    // Handle ratings update
    this.ratings = ratings;
    averageRating =
        ratings.fold(0, (sum, rating) => sum + rating.stars) / ratings.length;
    notifyListeners();
  }

  final RatingRepository ratingRepository;
  final UserRepository userRepository;

  bool isLoading = true;

  double averageRating = 0;
  List<Rating> ratings = [];

  String firstName = '';
  String lastName = '';
  bool isEditing = false;

  // TODO these should be updated from the repository somehow
  String email = 'mail';
  String password = 'perfectpassword';

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
    // Save changes logic here
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
    super.dispose();
  }
}
