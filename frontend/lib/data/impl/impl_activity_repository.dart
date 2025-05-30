import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class ImplActivityRepository implements ActivityRepository {
  ImplActivityRepository();

  final List<Activity> _activities = [
    Activity(
      id: 0,
      name: 'Activity 1',
      description: 'Activity 1 description',
      startTime: TimeOfDay(hour: 10, minute: 30),
      address: Address.fake(),
    ),
    Activity(
      id: 1,
      name: 'Activity 2',
      description: 'Activity 2 description',
      startTime: TimeOfDay(hour: 14, minute: 0),
      address: Address.fake(),
    ),
  ];
  final StreamController<List<Activity>> _activitiesController =
      StreamController<List<Activity>>.broadcast();

  void _notifyListeners() {
    _activitiesController.add(List.unmodifiable(_activities));
  }

  @override
  Future<void> create(Activity activity) async {
    try {
      if (_activities.any((a) => a.id == activity.id)) {
        throw Exception('Activity with id ${activity.id} already exists');
      }

      _activities.add(activity);
      _notifyListeners();
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  @override
  Future<void> delete(Activity activity) async {
    final index = _activities.indexWhere((a) => a.id == activity.id);

    if (index == -1) {
      throw Exception('Activity not found');
    }

    _activities.removeAt(index);
    _notifyListeners();
  }

  @override
  Future<List<Activity>> fetch() async {
    try {
      return List.unmodifiable(_activities);
    } catch (e) {
      throw Exception('Failed to fetch activities: $e');
    }
  }

  @override
  Future<void> update(Activity activity) async {
    try {
      final index = _activities.indexWhere((a) => a.id == activity.id);

      if (index == -1) {
        throw Exception('Activity not found');
      }

      _activities[index] = activity;
      _notifyListeners();
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  @override
  Stream<List<Activity>> watch() async* {
    try {
      // yield List.unmodifiable(_activities);
      yield* _activitiesController.stream;
    } catch (e) {
      yield* Stream.error('Failed to watch activities: $e');
    }
  }

  void dispose() {
    _activitiesController.close();
  }
}
