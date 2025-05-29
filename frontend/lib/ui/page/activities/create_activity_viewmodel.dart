import 'package:flutter/material.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/activity_repository.dart';

class CreateActivityViewModel extends ChangeNotifier {
  TimeOfDay? _timeOfDay;
  bool _isLoading = false;
  String? _errorMessage;
  Activity? _activity;
  Address? _address;

  String get name => nameController.text;
  String get description => descriptionController.text;
  TimeOfDay? get timeOfDay => _timeOfDay;
  Address? get address => _address;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Activity? get activity => _activity;

  final ActivityRepository _activityRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateActivityViewModel({
    required ActivityRepository activityRepository,
    Activity? activity,
  }) : _activityRepository = activityRepository,
       _activity = activity {
    if (activity != null) {
      nameController.text = activity.name;
      descriptionController.text = activity.description;
      _timeOfDay = activity.startTime;
      _address = activity.address;
    } else {
      // TODO
      _address = Address.fake();
    }
  }

  void selectTimeOfDay(TimeOfDay time) {
    _timeOfDay = time;
    notifyListeners();
  }

  Future<bool> editActivity() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _activityRepository.update(
        Activity(
          id: _activity!.id,
          name: nameController.text,
          description: descriptionController.text,
          startTime: _timeOfDay!,
          address: _address!,
        ),
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to edit activity: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createActivity() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (nameController.text.isEmpty) {
        _errorMessage = 'Please enter a name for the activity.';
        return false;
      }

      if (_timeOfDay == null) {
        _errorMessage = 'Please select a time for the activity.';
        return false;
      }

      if (_address == null) {
        _errorMessage = 'Please select an address for the activity.';
        return false;
      }

      _activityRepository.create(
        Activity(
          id: 0,
          name: nameController.text,
          description: descriptionController.text,
          startTime: _timeOfDay ?? TimeOfDay.now(),
          address: _address!,
        ),
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create activity: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
