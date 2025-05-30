import 'package:flutter/material.dart';
import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/report_repository.dart';

class ReportViewModel extends ChangeNotifier {
  bool _isSubmitting = false;
  String? _errorMessage;
  ReportReason? _reason;
  final ReportRepository _reportRepository;

  final TextEditingController descriptionController = TextEditingController();
  final User reported;

  bool get isSubmitting => _isSubmitting;
  String get description => descriptionController.text;
  ReportReason? get reason => _reason;
  String? get errorMessage => _errorMessage;
  bool get canSubmit => _reason != null;

  ReportViewModel({
    required ReportRepository reportRepository,
    required this.reported,
  }) : _reportRepository = reportRepository;

  void selectReason(ReportReason reason) {
    _reason = reason;
    notifyListeners();
  }

  Future<bool> submitReport() async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      await _reportRepository.create(
        reason: reason!,
        receiver: reported,
        details: description,
      );
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit report: $e';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
