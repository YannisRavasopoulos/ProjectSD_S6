import 'package:flutter/material.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/ui/page/profile/profile_viewmodel.dart';
import 'package:frontend/data/model/reward.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;
  final ProfileViewModel profileViewModel;

  List<Reward> _availableRewards = [];
  String _redemptionCode = '';
  String _errorMessage = '';
  bool _isLoading = false;

  RewardViewModel({
    required this.rewardRepository,
    required this.profileViewModel,
  }) {
    _loadRewards();
    profileViewModel.addListener(
      _onProfileUpdated,
    ); // Listen to ProfileViewModel updates
  }

  List<Reward> get availableRewards => List.unmodifiable(_availableRewards);
  String get redemptionCode => _redemptionCode;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  int get userPoints =>
      profileViewModel.points; // Fetch points from ProfileViewModel

  void _loadRewards() {
    _availableRewards = rewardRepository.getAllRewards();
    notifyListeners();
  }

  void _onProfileUpdated() {
    notifyListeners(); // Notify listeners when ProfileViewModel updates
  }

  Future<void> redeemReward(Reward reward) async {
    _isLoading = true;
    _errorMessage = '';
    _redemptionCode = '';
    notifyListeners();

    try {
      if (userPoints >= reward.points) {
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulating API call

        _redemptionCode = reward.code;

        final newPoints = userPoints - reward.points;
        await profileViewModel.updatePoints(
          newPoints,
        ); // Update points in ProfileViewModel

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

  @override
  void dispose() {
    profileViewModel.removeListener(_onProfileUpdated); // Clean up listener
    super.dispose();
  }
}
