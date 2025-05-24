import 'dart:math';

import 'package:frontend/data/impl/mock_user_repository.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/repository/reward_repository.dart';

class MockReward extends Reward {
  @override
  final String description;
  @override
  final int id;
  @override
  final int points;
  @override
  final String title;

  MockReward({
    required this.description,
    required this.id,
    required this.points,
    required this.title,
  });

  factory MockReward.random() {
    return MockReward(
      description: 'Mock Reward Description',
      id: DateTime.now().millisecondsSinceEpoch,
      points: Random().nextInt(100) + 1, // Random points between 1 and 100
      title: 'Mock Reward Title',
    );
  }
}

class MockRewardRepository implements RewardRepository {
  List<Reward> _availableRewards = List.generate(
    10,
    (index) => MockReward.random(),
  );

  List<Reward> _redeemedRewards = List.generate(
    3,
    (index) => MockReward.random(),
  );

  @override
  Future<List<Reward>> fetchAvailable() async {
    return _availableRewards;
  }

  @override
  Future<List<Reward>> fetchRedeemed() async {
    return _redeemedRewards;
  }

  @override
  Future<String> redeem(Reward reward) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));

    // Check if the reward is available
    if (_availableRewards.contains(reward)) {
      _availableRewards.remove(reward);
      _redeemedRewards.add(reward);
      var user = MockUserRepository.user;
      MockUserRepository.user = user.copyWith(
        points: user.points - reward.points,
      );
      return 'Reward redeemed successfully';
    } else {
      throw Exception('Reward not available');
    }
  }

  @override
  Stream<List<Reward>> watchAvailable() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield _availableRewards; // Emit the current available rewards
    }
  }

  @override
  Stream<List<Reward>> watchRedeemed() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield _redeemedRewards; // Emit the current redeemed rewards
    }
  }
}
