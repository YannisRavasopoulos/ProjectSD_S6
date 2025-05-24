import 'package:flutter/material.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;
  final UserRepository userRepository;

  RewardViewModel({
    required this.rewardRepository,
    required this.userRepository,
  }) {
    _fetchData();
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

  void redeem(Reward reward) async {
    if (_isLoading || _userPoints < reward.points) return;

    _isLoading = true;
    notifyListeners();

    try {
      await rewardRepository.redeem(reward);
      await _fetchData(); // Refresh available rewards
    } catch (e) {
      // Handle error as needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
