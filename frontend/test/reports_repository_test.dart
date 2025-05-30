import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:test/test.dart';
import 'package:frontend/data/impl/impl_report_repository.dart';
import 'package:frontend/data/model/report.dart';
import 'package:frontend/data/model/report_reason.dart';

//run with dart test -r expanded test/reports_repository_testing.dart
void main() {
  group('ReportRepository', () {
    late ReportRepository reportRepository;
    late UserRepository userRepository;
    late ImplReport report1;
    late ImplReport report2;

    setUp(() {
      userRepository = ImplUserRepository();
      reportRepository = ImplReportRepository(userRepository: userRepository as ImplUserRepository);
      report1 = ImplReport(
        id: 1,
        reason: ReportReason.spam,
        details: 'Spam report',
        createdAt: DateTime.now(),
      );
      report2 = ImplReport(
        id: 2,
        reason: ReportReason.harassment,
        details: 'Harassment report',
        createdAt: DateTime.now(),
      );
    });

    test('create adds a report', () async {
      await reportRepository.create(report1);
      final reports = await reportRepository.fetch();
      expect(reports.length, 1);
      expect(reports.first.id, report1.id);
      expect(reports.first.reason, report1.reason);
    });

    test('fetch returns all reports', () async {
      await reportRepository.create(report1);
      await reportRepository.create(report2);
      final reports = await reportRepository.fetch();
      expect(reports.length, 2);
      expect(reports[1].reason, ReportReason.harassment);
    });
    test('does not allow duplicate report IDs', () async {
      await reportRepository.create(report1);

      final duplicateReport = ImplReport(
        id: report1.id, // same ID as report1
        reason: ReportReason.harassment,
        details: 'Duplicate ID',
        createdAt: DateTime.now(),
      );

      expect(
        () async => await reportRepository.create(duplicateReport),
        throwsA(anything), // or throwsA(isA<Exception>())
      );
    });
    test('watch emits report updates', () async {
      final stream = reportRepository.watch();

      final future = expectLater(
        stream,
        emits(
          predicate<List<Report>>(
            (reports) => reports.isNotEmpty && reports.first.id == report1.id,
          ),
        ),
      );

      await reportRepository.create(report1);
      await future;
    });
  });
}

//note that the stream does not emit the initial state
