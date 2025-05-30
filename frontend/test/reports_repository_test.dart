import 'package:frontend/data/impl/impl_user_repository.dart';
import 'package:frontend/data/model/user.dart';
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
    late Report report1;
    late Report report2;
    late User testUser;

    setUp(() {
      userRepository = ImplUserRepository();
      reportRepository = ImplReportRepository(userRepository: userRepository as ImplUserRepository);
      testUser = User(
        id: 1,
        firstName: 'Test',
        lastName: 'User',
        points: 100,
      );
      report1 = Report(
        receiver: testUser, // Assuming fetchCurrent returns a User
        reason: ReportReason.spam,
        status: ReportStatus.pending,
        details: 'Spam report',
      );
      report2 = Report(
        receiver: testUser, // Assuming fetchCurrent returns a User
        reason: ReportReason.harassment,
        status: ReportStatus.pending,
        details: 'Spam report',
      );
    });

    test('create adds a report', () async {
      await reportRepository.create(receiver: testUser, reason: ReportReason.spam, details: 'Spam report');
      final reports = await reportRepository.fetch();
      expect(reports.length, 1);
      expect(reports[0].reason, ReportReason.spam);
    });
  test('does not allow duplicate report IDs', () async {
      await reportRepository.create(receiver: testUser, reason: ReportReason.spam, details: 'Spam report');
      await reportRepository.create(receiver: testUser, reason: ReportReason.harassment, details: 'Harassment report');
      final reports= await reportRepository.fetch();

      final reportIds = reports.map((report) => report.id).toList();
      final uniqueReportIds = reportIds.toSet();
      expect(uniqueReportIds.length, reports.length, reason: 'All report IDs should be unique');
    });
    test('fetch returns all reports', () async {
      await reportRepository.create(receiver: testUser, reason: ReportReason.spam, details: 'Spam report');
      await reportRepository.create(receiver: testUser, reason: ReportReason.harassment, details: 'Harassment report');
      final reports = await reportRepository.fetch();
      expect(reports.length, 2);
      expect(reports[0].reason, ReportReason.spam);
      expect(reports[1].reason, ReportReason.harassment);
    });
    test('watch emits report updates', () async {
      final stream = reportRepository.watch();

      final future = expectLater(
        stream,
        emits(
          predicate<List<Report>>(
            (reports) => reports.isNotEmpty && reports.last.details == 'this is a test report'
          ),
        ),
      );

      await reportRepository.create(receiver: testUser, reason: ReportReason.spam, details: 'this is a test report'); 
      await future;
    });
  });
}

//note that the stream does not emit the initial state
