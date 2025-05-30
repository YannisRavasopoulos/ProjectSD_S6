import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/redeemed_reward.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/repository/reward_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardRepository rewardRepository;
  final UserRepository userRepository;

  StreamSubscription<List<Reward>>? _availableSub;
  StreamSubscription<List<RedeemedReward>>? _redeemedSub;

  RewardViewModel({
    required this.rewardRepository,
    required this.userRepository,
  }) {
    _startWatchingRewards();
    _fetchUserPoints();
  }

  List<Reward> _availableRewards = [];
  List<RedeemedReward> _redeemedRewards = [];
  int _userPoints = 0;
  bool _isLoading = true;

  List<Reward> get availableRewards => _availableRewards;
  List<RedeemedReward> get redeemedRewards => _redeemedRewards;
  int get userPoints => _userPoints;
  bool get isLoading => _isLoading;

  void _startWatchingRewards() async {
    _isLoading = true;
    notifyListeners();

    _availableRewards = await rewardRepository.fetchAvailable();
    _redeemedRewards = await rewardRepository.fetchRedeemed();

    _isLoading = false;
    notifyListeners();

    _availableSub = rewardRepository.watchAvailable().listen((rewards) {
      _availableRewards = rewards;
      notifyListeners();
    });

    _redeemedSub = rewardRepository.watchRedeemed().listen((rewards) {
      _redeemedRewards = rewards;
      notifyListeners();
    });
  }

  Future<void> _fetchUserPoints() async {
    var user = await userRepository.fetchCurrent();
    _userPoints = user.points;
    notifyListeners();
  }

  Future<String?> redeem(Reward reward) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await rewardRepository.redeem(reward);
      await _fetchUserPoints();
      return result;
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _availableSub?.cancel();
    _redeemedSub?.cancel();
    super.dispose();
  }
}
