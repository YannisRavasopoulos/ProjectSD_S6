import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';

class ActivitiesViewModel extends ChangeNotifier {
  final List<Activity> _activities = [
    Activity(
      id: '1',
      name: 'Morning Commute',
      description: 'Daily commute to work',
      startLocation: 'Home',
      endLocation: 'Office',
    ),
    Activity(
      id: '2',
      name: 'Evening Gym',
      description: 'Ride to the gym',
      startLocation: 'Office',
      endLocation: 'Gym',
    ),
  ];

  List<Activity> get activities => _activities;

  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void removeActivity(String id) {
    _activities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  void editActivity(String id, Activity updatedActivity) {
    final index = _activities.indexWhere((activity) => activity.id == id);
    if (index != -1) {
      _activities[index] = updatedActivity;
      notifyListeners();
    }
  }
}
