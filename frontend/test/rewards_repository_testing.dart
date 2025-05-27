import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_rewards_repository.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/reward.dart';

void main() {
  group('RewardsRepositoryImpl', () {
    late ImplUserRepository userRepository;
    late RewardsRepositoryImpl rewardsRepository;

    setUp(() {
      userRepository = ImplUserRepository();
      rewardsRepository = RewardsRepositoryImpl(userRepository: userRepository);
    });

    test('fetchAvailable returns all available rewards', () async {
      final rewards = await rewardsRepository.fetchAvailable();
      expect(rewards.length, greaterThan(0));
      expect(rewards.first, isA<Reward>());
    });

    test('fetchRedeemed returns empty initially', () async {
      final rewards = await rewardsRepository.fetchRedeemed();
      expect(rewards, isEmpty);
    });

    test(
      'redeem moves reward from available to redeemed and updates user points',
      () async {
        final available = await rewardsRepository.fetchAvailable();
        final reward = available.first;
        final userBefore = await userRepository.fetchCurrent();
        final code = await rewardsRepository.redeem(reward);

        expect(code, (reward as RewardImpl).redemptionCode);

        final availableAfter = await rewardsRepository.fetchAvailable();
        final redeemed = await rewardsRepository.fetchRedeemed();
        final userAfter = await userRepository.fetchCurrent();

        expect(
          availableAfter.contains(reward),
          isFalse,
        ); //check if reward is no longer available
        expect(
          redeemed.contains(reward),
          isTrue,
        ); //check if reward is in redeemed
        expect(
          userAfter.points,
          userBefore.points - reward.points,
        ); //check points
      },
    );

    test('redeem throws if user does not have enough points', () async {
      final available = await rewardsRepository.fetchAvailable();
      // Set user points to 0
      final user = await userRepository.fetchCurrent();
      await userRepository.updateCurrentUser(
        (user as ImplUser).copyWith(points: 0),
      );
      final reward = available.first;

      expect(
        () async => await rewardsRepository.redeem(reward),
        throwsA(isA<Exception>()),
      );
    });

    test('watchAvailable emits available rewards', () async {
      final stream = rewardsRepository.watchAvailable();
      final future = expectLater(stream, emits(isA<List<Reward>>()));
      await future;
    });

    test('watchRedeemed emits redeemed rewards', () async {
      final stream = rewardsRepository.watchRedeemed();
      final future = expectLater(stream, emits(isA<List<Reward>>()));
      await future;
    });

    test(
      'redeem updates available and redeemed rewards via streams and updates user points',
      () async {
        final availableStream =
            rewardsRepository.watchAvailable().asBroadcastStream();
        final redeemedStream =
            rewardsRepository.watchRedeemed().asBroadcastStream();

        // get the initial available reward and user points
        final initialAvailable = await availableStream.first;
        final reward = initialAvailable.first;
        final userBefore = await userRepository.fetchCurrent();
        await rewardsRepository.redeem(reward);
        final availableFuture = expectLater(
          availableStream,
          emitsInOrder([
            predicate<List<Reward>>(
              (rewards) => !rewards.contains(reward),
            ), //does not contain redeemed reward
          ]),
        );

        final redeemedFuture = expectLater(
          redeemedStream,
          emitsInOrder([
            predicate<List<Reward>>(
              (rewards) => rewards.contains(reward),
            ), // contains redeemed reward
          ]),
        );

        await availableFuture;
        await redeemedFuture;
        //check user points after redeeming
        final userAfter = await userRepository.fetchCurrent();
        expect(userAfter.points, userBefore.points - reward.points);
      },
    );
  });
}
