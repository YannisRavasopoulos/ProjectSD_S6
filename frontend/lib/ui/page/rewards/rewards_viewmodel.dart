import 'package:flutter/material.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/user_repository.dart'; // Import UserRepository
import 'package:frontend/data/model/reward.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;
  final UserRepository userRepository; // Added UserRepository

  int _userPoints = 0; // Initialize to 0
  List<Reward> _availableRewards = [];
  String _redemptionCode = '';
  String _errorMessage = '';
  bool _isLoading = false;

  RewardViewModel({
    required this.rewardRepository,
    required this.userRepository, // Added parameter
  }) {
    _loadRewards();
    _loadUserPoints(); // Added points loading
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

  Future<void> _loadUserPoints() async {
    try {
      _userPoints = await userRepository.getUserPoints(1);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user points';
      notifyListeners();
    }
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

        final newPoints = _userPoints - reward.points;
        await userRepository.updateUserPoints(
          1,
          newPoints,
        ); // Replace with actual user ID
        _userPoints = newPoints;

        rewardRepository.removeReward(reward.id);
        _loadRewards();
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
