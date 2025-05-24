import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'dart:math';

class ReportViewModel extends ChangeNotifier {
  final ReportRepository reportRepository;

  bool _isLoading = false;
  String? _errorMessage;
  bool _submitted = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get submitted => _submitted;

  ReportViewModel({required this.reportRepository});

  Future<void> submitReport({
    required String reporterId,
    required String reportedUserId,
    required String rideId,
    required String reason,
    required String details,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _submitted = false;
    notifyListeners();

    try {
      final report = ImplReport(
        id: Random().nextInt(1000000),
        reporterId: reporterId,
        reportedUserId: reportedUserId,
        rideId: rideId,
        reason: reason,
        details: details,
        createdAt: DateTime.now(),
      );
      await reportRepository.create(report);
      _submitted = true;
    } catch (e) {
      _errorMessage = 'Failed to submit report: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _submitted = false;
    _errorMessage = null;
    notifyListeners();
  }
}
