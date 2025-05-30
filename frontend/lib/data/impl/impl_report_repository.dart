import 'dart:async';
import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/report_repository.dart';

class ImplReportRepository implements ReportRepository {
  // This sucks and is ugly but must be done for now...
  ImplReportRepository({required ImplUserRepository userRepository})
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

  int idCounter = 0;
  int get nextId => idCounter++;

  @override
  Future<void> create({
    required User receiver,
    required ReportReason reason,
    String? details,
  }) {
    try {
      var report = Report(
        id: nextId,
        receiver: receiver,
        reason: reason,
        details: details,
        status: ReportStatus.pending,
      );

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
