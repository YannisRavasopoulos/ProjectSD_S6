import 'package:frontend/data/model/report.dart';

abstract interface class ReportRepository {
  // Create a report
  Future<void> create(Report report);

  // Fetch reports filled by the user
  Future<List<Report>> fetch();

  // Watch for changes in reports filled by the user
  Stream<List<Report>> watch();
}
