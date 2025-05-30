import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/data/model/user.dart';

abstract interface class ReportRepository {
  // Create a report
  Future<void> create({
    required User receiver,
    required ReportReason reason,
    String? details,
  });

  // Fetch reports filled by the user
  Future<List<Report>> fetch();

  // Watch for changes in reports filled by the user
  Stream<List<Report>> watch();
}
