import 'package:flutter/material.dart';

class Reward {
  final String title;
  final String description;
  final int cost;

  Reward({required this.title, required this.description, required this.cost});
}

class RewardViewModel {
  // Notifiers for reactive updates
  final ValueNotifier<int> userPoints = ValueNotifier<int>(12345);
  final ValueNotifier<List<Reward>> availableRewards =
      ValueNotifier<List<Reward>>([
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
      ]);

  final ValueNotifier<String> redemptionCode = ValueNotifier<String>('');
  final ValueNotifier<String> errorMessage = ValueNotifier<String>('');
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> redeemReward(Reward reward) async {
    isLoading.value = true;
    errorMessage.value = '';
    redemptionCode.value = '';

    if (userPoints.value >= reward.cost) {
      await Future.delayed(Duration(seconds: 2));

      redemptionCode.value =
          'REDEEM-${reward.title.substring(0, 3).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch % 1000}';
      userPoints.value -= reward.cost;

      // Remove reward from list
      final updatedList = List<Reward>.from(availableRewards.value);
      updatedList.remove(reward);
      availableRewards.value = updatedList;
    } else {
      errorMessage.value = 'Not enough points to redeem this reward.';
    }

    isLoading.value = false;
  }

  void clearRedemptionCode() {
    redemptionCode.value = '';
  }
}
