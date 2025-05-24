import 'dart:async';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/repository/report_repository.dart';

class ImplReportRepository implements ReportRepository {
  final List<Report> _reports = [];
  final StreamController<List<Report>> _reportStreamController =
      StreamController.broadcast();

  void _notifyListeners() {
    _reportStreamController.add(List.unmodifiable(_reports));
  }

  @override
  Future<void> create(Report report) async {
    try {
      _reports.add(report);
      _notifyListeners();
      return Future.value();
    } catch (e) {
      return Future.error('Failed to create report: $e');
    }
  }

  @override
  Future<List<Report>> fetch() async {
    try {
      return Future.value(List.unmodifiable(_reports));
    } catch (e) {
      return Future.error('Failed to fetch reports: $e');
    }
  }

  @override
  Stream<List<Report>> watch() {
    try {
      return _reportStreamController.stream;
    } catch (e) {
      throw Exception('Failed to watch reports: $e');
    }
  }

  void dispose() {
    _reportStreamController.close();
  }
}
