import 'package:frontend/data/model/reward.dart';

class RewardRepository {
  final List<Reward> _rewards = List<Reward>.generate(
    10,
    (index) => Reward(
      id: index,
      name: 'Reward $index',
      description: 'Description for reward $index',
      code: 'Code $index',
      points: index * 10,
    ),
  );

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

  void removeReward(int id) {
    _rewards.removeWhere((reward) => reward.id == id);
  }
}
