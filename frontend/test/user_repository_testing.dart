import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/user.dart';

// run with dart test -r expanded test/user_repository_testing.dart
void main() {
  group('ImplUserRepository', () {
    late ImplUserRepository userRepository;

    setUp(() {
      userRepository = ImplUserRepository();
    });

    test('fetchCurrent returns default user', () async {
      final user = await userRepository.fetchCurrent();
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.points, 300);
    });

    test('updateCurrentUser updates the user', () async {
      final user = await userRepository.fetchCurrent();
      final updatedUser = (user as ImplUser).copyWith(points: 123);
      await userRepository.updateCurrentUser(updatedUser);
      final fetched = await userRepository.fetchCurrent();
      expect(fetched.points, 123);
    });

    test('watchCurrent emits user updates', () async {
      final user = await userRepository.fetchCurrent();
      final updatedUser = (user as ImplUser).copyWith(points: 456);

      final stream = userRepository.watchCurrent();
      final future = expectLater(
        stream,
        emits(predicate<User>((u) => u.points == 456)),
      );

      await userRepository.updateCurrentUser(updatedUser);
      await future;
    });
  });
}
