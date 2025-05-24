import 'package:frontend/data/mocks/mock_user_repository.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/repository/reward_repository.dart';

class RewardImpl extends Reward {
  @override
  final String description;
  @override
  final int id;
  @override
  final int points;
  @override
  final String title;

  RewardImpl({
    required this.description,
    required this.id,
    required this.points,
    required this.title,
  });
}

class RewardsRepositoryImpl implements RewardRepository {
  final List<Reward> _availableRewards = [
    RewardImpl(
      id: 1,
      title: 'Coffee Discount',
      description: 'Get 50% off your next coffee',
      points: 50,
    ),
    RewardImpl(
      id: 2,
      title: 'Free Appetizer',
      description: 'Enjoy a free appetizer at a local restaurant',
      points: 75,
    ),
    RewardImpl(
      id: 3,
      title: 'Movie Ticket',
      description: 'Get a free movie ticket',
      points: 120,
    ),
    RewardImpl(
      id: 4,
      title: 'Ride Discount',
      description: 'Get 20% off your next ride',
      points: 90,
    ),
    RewardImpl(
      id: 5,
      title: 'Book Discount',
      description: 'Get 30% off a book',
      points: 60,
    ),
    RewardImpl(
      id: 6,
      title: 'Snack Pack',
      description: 'Get a free snack pack',
      points: 40,
    ),
    RewardImpl(
      id: 7,
      title: 'Concert Ticket',
      description: 'Get a free concert ticket',
      points: 150,
    ),
    RewardImpl(
      id: 8,
      title: 'Museum Pass',
      description: 'Get a free museum pass',
      points: 100,
    ),
    RewardImpl(
      id: 9,
      title: 'Game Discount',
      description: 'Get 40% off a game',
      points: 80,
    ),
    RewardImpl(
      id: 10,
      title: 'Free Dessert',
      description: 'Enjoy a free dessert at a local cafe',
      points: 55,
    ),
  ];

  final List<Reward> _redeemedRewards = [];

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
