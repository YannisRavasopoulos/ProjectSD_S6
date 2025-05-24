import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/model/location.dart'; // Add this import

class ActivitiesViewModel extends ChangeNotifier {
  final ActivityRepository activityRepository;
  StreamSubscription<List<Activity>>? _activitiesSubscription;

  ActivitiesViewModel({required this.activityRepository}) {
    _init();
  }

  List<Activity>? _activities;
  bool _isLoading = true;
  String? _errorMessage;

  List<Activity>? get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _loadActivities();
    _activitiesSubscription = activityRepository.watch().listen(
      (activities) {
        _activities = activities;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      }
    );
  }

  Future<void> _loadActivities() async {
    try {
      _isLoading = true;
      notifyListeners();
      _activities = await activityRepository.fetch();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createActivity(ImplActivity activity) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await activityRepository.create(activity);
      await _loadActivities();
      
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateActivity(ImplActivity activity) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await activityRepository.update(activity);
      await _loadActivities();
      
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
      await activityRepository.delete(activity);
      await _loadActivities();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }
}
