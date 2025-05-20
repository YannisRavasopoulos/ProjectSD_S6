import 'package:frontend/data/model/activity.dart';

class ActivityRepository {
  List<Activity> activities = [];

  Future<List<Activity>> fetchActivities() async {
    if (activities.isEmpty) {
      // Simulate fetching from a database or API
      activities = List.generate(10, (index) => Activity.random());
    }
    return activities;
  }

  Future<void> insert(Activity activity) async {
    activities.add(activity);
  }

  Future<void> update(Activity activity) async {
    final index = activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      activities[index] = activity;
    }
  }

  Future<void> delete(int id) async {
    activities.removeWhere((activity) => activity.id == id);
  }
}
