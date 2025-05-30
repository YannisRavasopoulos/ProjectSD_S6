import 'package:frontend/data/model/activity.dart';

/// An abstract repository interface for managing user activities.
abstract interface class ActivityRepository {
  /// Creates an activity.
  Future<void> create(Activity activity);

  /// Fetches all current user's activities.
  Future<List<Activity>> fetch();

  /// Watches for changes in the current user's activities.
  Stream<List<Activity>> watch();

  /// Updates the specified activity.
  Future<void> update(Activity activity);

  /// Delete the specified activity.
  Future<void> delete(Activity activity);
}
