import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/report_reason.dart';

//run with dart test -r expanded test/reports_repository_testing.dart
//using setup recreates the repository before each test
void main() {
  group('ReportRepository', () {
    late ReportRepository reportRepository;
    late UserRepository userRepository;

    setUp(() {
      userRepository = ImplUserRepository();
      reportRepository = ImplReportRepository(userRepository: userRepository as ImplUserRepository
      );
    });

    test('create adds a report', () async {
      final report = ImplReport(
        id: 1,
        reason: ReportReason.spam,
        details: 'Spam report',
        createdAt: DateTime.now(),
      );
      await reportRepository.create(report);
      final reports = await reportRepository.fetch();
      expect(reports.length, 1);
      expect(reports.first.id, 1);
      expect(reports.first.reason, ReportReason.spam);
    });

    test('fetch returns all reports', () async {
      final report1 = ImplReport(
        id: 1,
        reason: ReportReason.spam,
        details: 'Spam report',
        createdAt: DateTime.now(),
      );
      final report2 = ImplReport(
        id: 2,
        reason: ReportReason.harassment,
        details: 'Harassment report',
        createdAt: DateTime.now(),
      );
      await reportRepository.create(report1);
      await reportRepository.create(report2);
      final reports = await reportRepository.fetch();
      expect(reports.length, 2);
      expect(reports[1].reason, ReportReason.harassment);
    });

    test('watch emits report updates', () async {
      final report = ImplReport(
        id: 1,
        reason: ReportReason.spam,
        details: 'Spam report',
        createdAt: DateTime.now(),
      );
      final stream = reportRepository.watch();

      final future = expectLater(
        stream,
        emits(
          predicate<List<Report>>(
            (reports) => reports.isNotEmpty && reports.first.id == 1,
          ),
        ),
      );

      await reportRepository.create(report);
      await future;
    });
  });
}

//note that the stream does not emit the initial state
