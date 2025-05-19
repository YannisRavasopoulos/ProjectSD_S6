import 'package:flutter/material.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/model/reward.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;

  int _userPoints = 12345;
  List<Reward> _availableRewards = [];
  String _redemptionCode = '';
  String _errorMessage = '';
  bool _isLoading = false;

  RewardViewModel({required this.rewardRepository}) {
    _loadRewards();
  }

  // Getters
  int get userPoints => _userPoints;
  List<Reward> get availableRewards => List.unmodifiable(_availableRewards);
  String get redemptionCode => _redemptionCode;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _loadRewards() {
    _availableRewards = rewardRepository.getAllRewards();
    notifyListeners();
  }

  Future<void> redeemReward(Reward reward) async {
    _isLoading = true;
    _errorMessage = '';
    _redemptionCode = '';
    notifyListeners();

    try {
      if (_userPoints >= reward.points) {
        await Future.delayed(Duration(seconds: 1)); // Simulating API call

        _redemptionCode =
            'REDEEM-${reward.name.substring(0, 3).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch % 1000}';
        _userPoints -= reward.points;

        rewardRepository.removeReward(reward.id);
        _loadRewards(); // Reload rewards from repository
      } else {
        _errorMessage = 'Not enough points to redeem this reward';
      }
    } catch (e) {
      _errorMessage = 'Failed to redeem reward: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearRedemptionCode() {
    _redemptionCode = '';
    notifyListeners();
  }
}
