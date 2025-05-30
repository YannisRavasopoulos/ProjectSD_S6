import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/redeemed_reward.dart';
import 'package:frontend/data/model/reward.dart';
import 'package:frontend/data/repository/reward_repository.dart';

class RewardsRepositoryImpl implements RewardRepository {
  final ImplUserRepository userRepository;

  RewardsRepositoryImpl({required this.userRepository});

  final List<Reward> _availableRewards = [
    RedeemedReward(
      id: 1,
      title: 'Coffee Discount',
      description: 'Get 50% off your next coffee',
      points: 50,
      redemptionCode: 'COFFEE50',
    ),
    RedeemedReward(
      id: 2,
      title: 'Free Appetizer',
      description: 'Enjoy a free appetizer at a local restaurant',
      points: 75,
      redemptionCode: 'APPETIZERFREE',
    ),
    RedeemedReward(
      id: 3,
      title: 'Movie Ticket',
      description: 'Get a free movie ticket',
      points: 120,
      redemptionCode: 'MOVIEPASS',
    ),
    RedeemedReward(
      id: 4,
      title: 'Ride Discount',
      description: 'Get 20% off your next ride',
      points: 90,
      redemptionCode: 'RIDE20',
    ),
    RedeemedReward(
      id: 5,
      title: 'Book Discount',
      description: 'Get 30% off a book',
      points: 60,
      redemptionCode: 'BOOK30',
    ),
    RedeemedReward(
      id: 6,
      title: 'Snack Pack',
      description: 'Get a free snack pack',
      points: 40,
      redemptionCode: 'SNACKFREE',
    ),
    RedeemedReward(
      id: 7,
      title: 'Concert Ticket',
      description: 'Get a free concert ticket',
      points: 150,
      redemptionCode: 'CONCERTPASS',
    ),
    RedeemedReward(
      id: 8,
      title: 'Museum Pass',
      description: 'Get a free museum pass',
      points: 100,
      redemptionCode: 'MUSEUM100',
    ),
    RedeemedReward(
      id: 9,
      title: 'Game Discount',
      description: 'Get 40% off a game',
      points: 80,
      redemptionCode: 'GAME40',
    ),
    RedeemedReward(
      id: 10,
      title: 'Free Dessert',
      description: 'Enjoy a free dessert at a local cafe',
      points: 55,
      redemptionCode: 'DESSERTFREE',
    ),
  ];

  final List<RedeemedReward> _redeemedRewards = [];

  @override
  Future<List<Reward>> fetchAvailable() async {
    return _availableRewards;
  }

  @override
  Future<List<RedeemedReward>> fetchRedeemed() async {
    return _redeemedRewards;
  }

  @override
  Future<String> redeem(Reward reward) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));

    if (_availableRewards.contains(reward)) {
      _availableRewards.remove(reward);
      _redeemedRewards.add(reward as RedeemedReward);

      final user = await userRepository.fetchCurrent();
      if (user.points < reward.points) {
        throw Exception('Not enough points');
      }
      final updatedUser = user.copyWith(points: user.points - reward.points);
      await userRepository.updateCurrentUser(updatedUser);

      return reward.redemptionCode;
    } else {
      throw Exception('Reward not available');
    }
  }

  @override
  Stream<List<Reward>> watchAvailable() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield _availableRewards;
    }
  }

  @override
  Stream<List<RedeemedReward>> watchRedeemed() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield _redeemedRewards;
    }
  }
}
