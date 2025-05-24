import 'dart:async';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class ImplActivityRepository implements ActivityRepository{

   final List<Activity> _activities = [];
   final StreamController<List<Activity>> _activitiesController = StreamController<List<Activity>>.broadcast();


  void _notifyListeners() {
    _activitiesController.add(List.unmodifiable(_activities));
  }

  @override
  Future<void> create(Activity activity) async {
    try {
      _activities.add(activity);
      _notifyListeners();
    } catch (e) {
      return Future.error('Failed to create activity: $e');
    }
  }

  @override
  Future<void> delete(Activity activity) async {
    try {
      final removed = _activities.remove(activity);
      if (!removed) {
        return Future.error('Activity not found');
      }
      _notifyListeners();
    } catch (e) {
      return Future.error('Failed to delete activity: $e');
    }
  }

  @override
   Future<List<Activity>> fetch() async {
    try {
      return List.unmodifiable(_activities);
    } catch (e) {
      return Future.error('Failed to fetch activities: $e');
    }
  }

  @override
  Future<void> update(Activity activity) async {
    try {
      final index = _activities.indexWhere((a) => a == activity);
      if (index == -1) {
        return Future.error('Activity not found');
      }
      _activities[index] = activity;
      _notifyListeners();
    } catch (e) {
      return Future.error('Failed to update activity: $e');
    }
  }


  @override
  Stream<List<Activity>> watch() async* {  //emits the current list of activities every time there is a change to listen for real-time updates
    try {
      yield List.unmodifiable(_activities);
      yield* _activitiesController.stream;
    } catch (e) {
      yield* Stream.error('Failed to watch activities: $e');
    }
  }
  


  void dispose() {
    _activitiesController.close();
  }

}