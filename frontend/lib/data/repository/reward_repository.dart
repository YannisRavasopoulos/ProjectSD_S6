import 'package:frontend/data/model/reward.dart';

class RewardRepository {
  final List<Reward> _rewards = [
    Reward(
      id: '1',
      name: 'Free Coffee',
      description: 'Enjoy a free coffee at our store.',
      points: 100,
    ),
    Reward(
      id: '2',
      name: 'Discount Coupon',
      description: 'Get a 10% discount on your next purchase.',
      points: 200,
    ),
    Reward(
      id: '3',
      name: 'Gift Card',
      description: 'Redeem this gift card at any partner store.',
      points: 500,
    ),
  ];

  List<Reward> getAllRewards() {
    return List<Reward>.from(_rewards);
  }

  Reward getRewardById(String id) {
    try {
      return _rewards.firstWhere((reward) => reward.id == id);
    } catch (e) {
      throw Exception('Reward with id $id not found');
    }
  }

  void addReward(Reward reward) {
    _rewards.add(reward);
  }

  void removeReward(String id) {
    _rewards.removeWhere((reward) => reward.id == id);
  }
}
