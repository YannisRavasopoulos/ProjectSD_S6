import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart'; 

void main() {
  group('ActivityRepository', () {
    late ImplActivityRepository activityRepository;
    late Address address1;
    late Address address2;
    late Activity activity1;
    late Activity activity2;
    late int initialActivitiesNum;

    setUp(() {

       
      activityRepository = ImplActivityRepository();
      initialActivitiesNum = 2; //assuming there are 2 initial activities in the repository
      address1 = Address(
        coordinates: LatLng(0.0, 0.0),
        city: 'City1',
        street: 'Street1',
        number: 1,
        postalCode: '11111',
      );
      address2 = Address(
        coordinates: LatLng(1.0, 1.0),
        city: 'City2',
        street: 'Street2',
        number: 2,
        postalCode: '22222',
      );
      activity1 = Activity(
        id: 3,
        name: 'Test Activity 1',
        description: 'Test Description 1',
        startTime: TimeOfDay(hour: 10, minute: 0),
        address: address1,
      );
      activity2 = Activity(
        id: 4,
        name: 'Test Activity 2',
        description: 'Test Description 2',
        startTime: TimeOfDay(hour: 11, minute: 0),
        address: address2,
      );
      
    });

    test('create adds an activity', () async {

      await activityRepository.create(activity1);
      final activities = await activityRepository.fetch();
      expect(activities.length, initialActivitiesNum + 1);
      expect(activities[initialActivitiesNum].id, initialActivitiesNum+1);
    });

    test('fetch returns all activities', () async {
      await activityRepository.create(activity1);
      await activityRepository.create(activity2);
      final activities = await activityRepository.fetch();
      expect(activities.length, initialActivitiesNum + 2);
      expect(activities[initialActivitiesNum].name, 'Test Activity 1');
      expect(activities[initialActivitiesNum+1].name, 'Test Activity 2');
    });

    test('update modifies an existing activity', () async {
      await activityRepository.create(activity1);

      final updatedActivity = Activity(
        id: 3,
        name: 'Updated Activity',
        description: 'Updated Description',
        startTime: activity1.startTime,
        address: address1,
      );
      await activityRepository.update(updatedActivity);
      final activities = await activityRepository.fetch();
      expect(activities.length, initialActivitiesNum + 1);
      expect(activities[initialActivitiesNum].name, 'Updated Activity');
    });

    test('delete removes an activity', () async {
      await activityRepository.create(activity1);
      await activityRepository.delete(activity1);
      final activities = await activityRepository.fetch();
      expect(activities.length, initialActivitiesNum);
    });

    test('delete throws error if activity not found', () async {
      final nonExistentActivity = Activity(
        id: 999,
        name: 'Nonexistent Activity',
        description: 'Does not exist',
        startTime: TimeOfDay(hour: 12, minute: 0),
        address: address1,
      );
      expect(
        () async => await activityRepository.delete(nonExistentActivity),
        throwsA('Activity not found'),
      );
    });

    test('update throws error if activity not found', () async {
      final nonExistentActivity = Activity(
        id: 999,
        name: 'Nonexistent Activity',
        description: 'Does not exist',
        startTime: TimeOfDay(hour: 12, minute: 0),
        address: address1,
      );
      expect(
        () async => await activityRepository.update(nonExistentActivity),
        throwsA('Activity not found'),
      );
    });

    test('does not allow duplicate activity IDs', () async {
    await activityRepository.create(activity1);
    final duplicateActivity = Activity(
      id: activity1.id,
      name: 'Duplicate Activity',
      description: 'Should not be allowed',
      startTime: TimeOfDay(hour: 12, minute: 0),
      address: address2,
    );
    expect(
      () async => await activityRepository.create(duplicateActivity),
      throwsA(anything),
    );

  });

    test('watch emits activity updates', () async {
      final stream = activityRepository.watch();

      final future = expectLater(
        stream,
        emits(
          predicate<List>(
            (activities) => activities.isNotEmpty && activities.last.id == activity1.id,
          ),
        ),
      );

      await activityRepository.create(activity1);
      await future;
    });

    test('stream emits on create and delete', () async {
      final stream = activityRepository.watch();

      final future = expectLater(
        stream,
        emitsInOrder([
          predicate<List>(
            (activities) =>
                activities.length == initialActivitiesNum+1 && activities.last.id == activity1.id,
          ),
          predicate<List>(
            (activities) =>
                activities.length == initialActivitiesNum  &&
                activities.every((a) => a.id != activity1.id),
          ),
        ]),
      );
      await activityRepository.create(activity1);
      await activityRepository.delete(activity1);
      await future;
    });
    

  });
}
