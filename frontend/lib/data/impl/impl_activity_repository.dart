import 'dart:async';
import 'package:flutter/material.dart';

import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/repository/activity_repository.dart';
import 'package:frontend/data/model/location.dart';

class ImplActivity extends Activity {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final TimeOfDay startTime;
  @override
  final TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0); // Default value
  @override
  final Location startLocation;
  @override
  final Location endLocation;

  ImplActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ImplActivityRepository implements ActivityRepository {
  static final ImplActivityRepository _instance =
      ImplActivityRepository._internal();

  factory ImplActivityRepository() {
    return _instance;
  }

  ImplActivityRepository._internal();

  final List<Activity> _activities = [];
  final StreamController<List<Activity>> _activitiesController =
      StreamController<List<Activity>>.broadcast();

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
      final index = _activities.indexWhere((a) => a.id == activity.id);
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
  Stream<List<Activity>> watch() async* {
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

