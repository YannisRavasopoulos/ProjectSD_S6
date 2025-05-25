import 'dart:async';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/mocks/mock_user_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';

class ImplReport extends Report {
  @override
  final int id;
  @override
  final ReportReason reason;
  @override
  final ReportStatus status = ReportStatus.pending;
  @override
  final User receiver = MockUser.random();

  final String details;
  final DateTime createdAt;

  ImplReport({
    required this.id,
    required this.reason,
    required this.details,
    required this.createdAt,
  });
}

class ImplReportRepository implements ReportRepository {
  // This sucks and is ugly but must be done for now...
  ImplReportRepository(ImplUserRepository userRepository)
    : _userRepository = userRepository;

  final ImplUserRepository _userRepository;
  final List<Report> _reports = [];
  final StreamController<List<Report>> _reportStreamController =
      StreamController.broadcast();

  void _notifyListeners() {
    _reportStreamController.add(List.unmodifiable(_reports));
  }

  bool _shouldApplyPenalty(User user) {
    // Must have at least 3 reports to apply a penalty
    final reports = _reports.where((report) => report.receiver.id == user.id);
    return reports.length >= 3;
  }

  void _applyPenalty(User user) {
    // TODO
    print('Penalty applied to user ${user.name}.');
  }

  @override
  Future<void> create(Report report) async {
    try {
      _reports.add(report);

      if (_shouldApplyPenalty(report.receiver)) {
        _applyPenalty(report.receiver);
      }

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
