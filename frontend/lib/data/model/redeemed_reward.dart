import 'package:frontend/data/model/reward.dart';

class RedeemedReward extends Reward {
  final String redemptionCode;

  RedeemedReward({
    required super.description,
    required super.id,
    required super.points,
    required super.title,
    required this.redemptionCode,
  });
}
