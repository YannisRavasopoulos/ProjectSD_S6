import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/repository/pickup_repository.dart';

class ConfirmPickupViewModel extends ChangeNotifier {
  final PickupRepository pickupRepository;
  final Pickup pickup;

  bool _isLoading = false;
  String? _errorMessage;

  ConfirmPickupViewModel({
    required this.pickupRepository,
    required this.pickup,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> acceptPickup() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await pickupRepository.acceptPickup(pickup);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to confirm pickup: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectPickup() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await pickupRepository.rejectPickup(pickup);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to reject pickup: $e';
      notifyListeners();
      return false;
    }
  }
}