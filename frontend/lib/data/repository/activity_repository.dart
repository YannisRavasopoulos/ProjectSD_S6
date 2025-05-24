import 'package:frontend/data/model/activity.dart';

abstract interface class ActivityRepository {
  /// Create an activity
  Future<void> create(Activity activity);

  /// Fetch all user activities
  Future<List<Activity>> fetch();

  /// Watch for changes in user activities
  Stream<List<Activity>> watch();

  /// Update an activity
  Future<void> update(Activity activity);

  /// Delete an activity
  Future<void> delete(Activity activity);
}
