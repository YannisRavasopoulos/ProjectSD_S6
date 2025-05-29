import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class ActivitiesViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;

  bool get isLoading => _isLoading;
  List<Activity> get activities => _activities;
  String? get errorMessage => _errorMessage;

  bool _isLoading = true;
  List<Activity> _activities = [];
  String? _errorMessage;

  ActivitiesViewModel({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository {
    _init();
  }

  StreamSubscription<List<Activity>>? _activitiesSubscription;

  void _onActivitiesUpdated(List<Activity> activities) {
    _activities = activities;
    notifyListeners();
  }

  void _init() async {
    _activitiesSubscription = _activityRepository.watch().listen(
      _onActivitiesUpdated,
    );

    _activities = await _activityRepository.fetch();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }

  Future<bool> deleteActivity(Activity activity) async {
    try {
      await _activityRepository.delete(activity);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }
}
