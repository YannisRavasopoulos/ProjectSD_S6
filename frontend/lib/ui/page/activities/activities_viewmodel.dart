import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class ActivitiesViewModel extends ChangeNotifier {
  ActivitiesViewModel({required this.activityRepository}) {
    _init();
  }

  bool isLoading = false;

  final ActivityRepository activityRepository;
  List<Activity>? activities;

  void _init() async {
    isLoading = true;
    notifyListeners();

    activities = await activityRepository.fetch();
    isLoading = false;
    notifyListeners();
  }

  void addActivity(Activity activity) {
    // activityRepository.insert
    notifyListeners();
  }

  void removeActivity(String id) {
    // _activities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  void editActivity(String id, Activity updatedActivity) {
    // final index = _activities.indexWhere((activity) => activity.id == id);
    // if (index != -1) {
    //   _activities[index] = updatedActivity;
    //   notifyListeners();
    // }
  }
}
