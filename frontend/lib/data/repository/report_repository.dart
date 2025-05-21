import 'package:frontend/data/model/report.dart';

class ReportRepository {
  final List<Report> _reports = [];

  Future<void> submitReport(Report report) async {
    // TODO: Replace with API call
    await Future.delayed(const Duration(milliseconds: 500));
    _reports.add(report);
  }

  List<Report> getReportsForUser(String userId) {
    return _reports.where((r) => r.reportedUserId == userId).toList();
  }
}