import 'package:frontend/data/model/redeemed_reward.dart';
import 'package:frontend/data/model/reward.dart';

abstract interface class RewardRepository {
  /// Redeems a reward for the user. Returns the coupon code.
  Future<String> redeem(Reward reward);

  /// Fetches the available rewards.
  Future<List<Reward>> fetchAvailable();

  /// Watches for changes in the available rewards.
  Stream<List<Reward>> watchAvailable();

  /// Fetches the redeemed rewards.
  Future<List<RedeemedReward>> fetchRedeemed();

  /// Watches for changes in the redeemed rewards.
  Stream<List<RedeemedReward>> watchRedeemed();
}
