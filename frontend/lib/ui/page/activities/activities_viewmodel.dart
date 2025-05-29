import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class ActivitiesViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;

  bool get isLoading => _isLoading;
  List<Activity> get activities => _activities;

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

  // Future<void> _loadActivities() async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     _activities = await activityRepository.fetch();
  //     _errorMessage = null;
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> createActivity(Activity activity) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _activityRepository.create(activity);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateActivity(Activity activity) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _activityRepository.update(activity);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteActivity(Activity activity) async {
    try {
      await _activityRepository.delete(activity);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
