import 'package:flutter/material.dart';

class Reward {
  final String title;
  final String description;
  final int cost;

  Reward({required this.title, required this.description, required this.cost});
}

class RewardViewModel extends ChangeNotifier {
  int _userPoints = 12345;
  List<Reward> _availableRewards = [
    Reward(
      title: '10% Discount',
      description: 'Get 10% off your next ride',
      cost: 1000,
    ),
    Reward(
      title: 'Free Coffee',
      description: 'Enjoy a free coffee at participating locations',
      cost: 2000,
    ),
    Reward(
      title: 'Priority Booking',
      description: 'Get priority booking for your next ride',
      cost: 3000,
    ),
  ];
  String _redemptionCode = '';
  String _errorMessage = '';
  bool _isLoading = false;

  // Getters
  int get userPoints => _userPoints;
  List<Reward> get availableRewards => List.unmodifiable(_availableRewards);
  String get redemptionCode => _redemptionCode;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> redeemReward(Reward reward) async {
    _isLoading = true;
    _errorMessage = '';
    _redemptionCode = '';
    notifyListeners();

    if (_userPoints >= reward.cost) {
      await Future.delayed(Duration(seconds: 2));

      _redemptionCode =
          'REDEEM-${reward.title.substring(0, 3).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch % 1000}';
      _userPoints -= reward.cost;

      _availableRewards = List<Reward>.from(_availableRewards)..remove(reward);
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearRedemptionCode() {
    _redemptionCode = '';
    notifyListeners();
  }
}
