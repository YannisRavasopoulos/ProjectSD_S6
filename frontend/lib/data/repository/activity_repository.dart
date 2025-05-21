import 'package:frontend/data/model/activity.dart';

class ActivityRepository {
  List<Activity> _activities = [];

  // Create an activity
  Future<void> create(Activity activity) async {
    _activities.add(activity);
  }

  // Fetch all user activities
  Future<List<Activity>> fetch() async {
    return _activities;
  }

  // Watch for changes in activities
  Stream<List<Activity>> watch() async* {
    while (true) {
      // Update activities every 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      yield await fetch();
    }
  }

  // Update an activity
  Future<void> update(Activity activity) async {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
    }
  }

  // Delete an activity
  Future<void> delete(int id) async {
    _activities.removeWhere((activity) => activity.id == id);
  }
}
