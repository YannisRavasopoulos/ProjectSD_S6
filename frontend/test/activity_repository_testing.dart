import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ImplActivityRepository', () {
    late ImplActivityRepository activityRepository;

    setUp(() {
      activityRepository = ImplActivityRepository();
    });

    test('create adds an activity', () async {
      final activity = ImplActivity(
        id: 1,
        name: 'Test Activity',
        description: 'Test Description',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
        startLocation: ImplLocation(
          id: 1,
          coordinates: LatLng(0.0, 0.0),
          name: 'Start Location',
        ),
        endLocation: ImplLocation(
          id: 2,
          coordinates: LatLng(1.0, 1.0),
          name: 'End Location',
        ),
      );
      await activityRepository.create(activity);
      final activities = await activityRepository.fetch();
      expect(activities.length, 1);
    });
  });
}
