import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ImplActivityRepository', () {
    late ImplActivityRepository activityRepository;
    late ImplLocation startLocation;
    late ImplLocation endLocation;
    late ImplActivity activity1;
    late ImplActivity activity2;

    setUp(() {
      activityRepository = ImplActivityRepository();
      startLocation = ImplLocation(
        id: 1,
        name: 'Start Location',
        coordinates: LatLng(0.0, 0.0),
      );
      endLocation = ImplLocation(
        id: 2,
        name: 'End Location',
        coordinates: LatLng(1.0, 1.0),
      );
      activity1 = ImplActivity(
        id: 1,
        name: 'Test Activity 1',
        description: 'Test Description 1',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        startLocation: startLocation,
        endLocation: endLocation,
      );
      activity2 = ImplActivity(
        id: 2,
        name: 'Test Activity 2',
        description: 'Test Description 2',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        startLocation: startLocation,
        endLocation: endLocation,
      );
    });

    test('create adds an activity', () async {
      await activityRepository.create(activity1);
      final activities = await activityRepository.fetch();
      expect(activities.length, 1);
      expect(activities.first.id, 1);
    });

    test('fetch returns all activities', () async {
      await activityRepository.create(activity1);
      await activityRepository.create(activity2);
      final activities = await activityRepository.fetch();
      expect(activities.length, 2);
      expect(activities[0].name, 'Test Activity 1');
      expect(activities[1].name, 'Test Activity 2');
    });

    test('update modifies an existing activity', () async {
      await activityRepository.create(activity1);

      final updatedActivity = ImplActivity(
        id: 1,
        name: 'Updated Activity',
        description: 'Updated Description',
        startTime: activity1.startTime,
        endTime: activity1.endTime,
        startLocation: startLocation,
        endLocation: endLocation,
      );
      await activityRepository.update(updatedActivity);
      final activities = await activityRepository.fetch();
      expect(activities.length, 1);
      expect(activities.first.name, 'Updated Activity');
    });

    test('delete removes an activity', () async {
      await activityRepository.create(activity1);
      await activityRepository.delete(activity1);
      final activities = await activityRepository.fetch();
      expect(activities.isEmpty, true);
    });

    test('delete throws error if activity not found', () async {
      final nonExistentActivity = ImplActivity(
        id: 999,
        name: 'Nonexistent Activity',
        description: 'Does not exist',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        startLocation: startLocation,
        endLocation: endLocation,
      );
      expect(
        () async => await activityRepository.delete(nonExistentActivity),
        throwsA('Activity not found'),
      );
    });

    test('update throws error if activity not found', () async {
      final nonExistentActivity = ImplActivity(
        id: 999,
        name: 'Nonexistent Activity',
        description: 'Does not exist',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        startLocation: startLocation,
        endLocation: endLocation,
      );
      expect(
        () async => await activityRepository.update(nonExistentActivity),
        throwsA('Activity not found'),
      );
    });

    test('watch emits activity updates', () async {
      final stream = activityRepository.watch();

      final future = expectLater(
        stream,
        emits(
          predicate<List>(
            (activities) => activities.isNotEmpty && activities.first.id == 1,
          ),
        ),
      );

      await activityRepository.create(activity1);
      await future;
    });

    test('stream emits on create and delete ', () async {
      final stream = activityRepository.watch();

      final future = expectLater(
        stream,
        emitsInOrder([
          predicate<List>(
            (activities) =>
                activities.isNotEmpty && activities.first.id == activity1.id,
          ),
          predicate<List>((activities) => activities.isEmpty),
        ]),
      );
      await activityRepository.create(activity1);
      await activityRepository.delete(activity1);
      await future;
    });
  });
}
