import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/data/model/user.dart';

enum ReportStatus { pending, inProgress, resolved, rejected }

class Report {
  final ReportReason reason;
  final User receiver;
  final ReportStatus status;
  final String? details;

  Report({
    required this.receiver,
    required this.reason,
    required this.status,
    this.details,
  });
}
