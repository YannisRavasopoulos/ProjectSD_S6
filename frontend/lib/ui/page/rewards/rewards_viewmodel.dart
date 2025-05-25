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

  Future<String?> redeem(Reward reward) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await rewardRepository.redeem(reward);
      await _fetchData(); // Refresh available rewards
      return result; // Return the redemption code
    } catch (e) {
      // Handle error as needed
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
