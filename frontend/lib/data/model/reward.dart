class Reward {
  final String id;
  final String name;
  final String description;
  final int points;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
  });

  static Reward random() {
    final List<String> names = [
      'Free Coffee',
      'Discount Coupon',
      'Gift Card',
      'Bonus Points',
      'Mystery Box',
    ];
    final List<String> descriptions = [
      'Enjoy a free coffee at our store.',
      'Get a 10% discount on your next purchase.',
      'Redeem this gift card at any partner store.',
      'Earn extra bonus points for your account.',
      'Open the box for a surprise reward!',
    ];
    final random = DateTime.now().millisecondsSinceEpoch;
    final index = random % names.length;
    return Reward(
      id: 'reward_${random}',
      name: names[index],
      description: descriptions[index],
      points: 10 + (random % 91), // random points between 10 and 100
    );
  }
}
