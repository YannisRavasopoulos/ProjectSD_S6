import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'dart:async';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;
  final UserRepository userRepository;
  StreamSubscription<User>? _userSubscription;

  RewardViewModel({
    required this.rewardRepository,
    required this.userRepository,
  }) {
    _init();
  }

  void _init() {
    _fetchData();
    // Listen to user changes
    _userSubscription = userRepository.watchCurrent().listen(_onUserUpdate);
  }

  void _onUserUpdate(User user) {
    if (user is ImplUser) {
      _userPoints = user.points;
      notifyListeners();
    }
  }

  List<Reward> _availableRewards = [];
  List<Reward> _redeemedRewards = [];
  int _userPoints = 0;
  bool _isLoading = true;

  List<Reward> get availableRewards => _availableRewards;
  List<Reward> get redeemedRewards => _redeemedRewards;
  int get userPoints => _userPoints;
  bool get isLoading => _isLoading;

  Future<void> _fetchData() async {
    _isLoading = true;
    notifyListeners();

    _availableRewards = await rewardRepository.fetchAvailable();
    _redeemedRewards = await rewardRepository.fetchRedeemed();
    var user = await userRepository.fetchCurrent();
    _userPoints = user.points;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _fetchData();
  }

  Future<String?> redeem(Reward reward) async {
    if (_isLoading || _userPoints < reward.points) return null;

    _isLoading = true;
    notifyListeners();

    try {
      // Get current user first
      final currentUser = await userRepository.fetchCurrent();
      if (currentUser is ImplUser) {
        // Update user points first
        final updatedUser = currentUser.copyWith(
          points: currentUser.points - reward.points,
        );
        await userRepository.updateCurrentUser(updatedUser);

        // Then redeem the reward
        final code = await rewardRepository.redeem(reward);

        // Finally refresh the data
        await _fetchData();
        return code;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
