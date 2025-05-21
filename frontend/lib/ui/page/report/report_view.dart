import 'package:flutter/material.dart';
import 'report_form.dart';
import 'report_viewmodel.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/data/model/user.dart';

class ReportView extends StatelessWidget {
  final ReportViewModel viewModel;

  const ReportView({super.key, required this.viewModel});

  Future<String> _getReportedUserName(String userId) async {
    final userRepository = UserRepository();
    User? user = await userRepository.fetchForId(int.parse(userId));
    return user?.firstName ?? 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    // For demo, hardcode reportedUserId
    final reportedUserId = '2';

    // State holders
    final selectedReason = ValueNotifier<String?>(null);
    final details = ValueNotifier<String>('');
    final isLoading = ValueNotifier<bool>(false);
    final submitted = ValueNotifier<bool>(false);
    final errorMessage = ValueNotifier<String?>(null);

    return FutureBuilder<String>(
      future: _getReportedUserName(reportedUserId),
      builder: (context, snapshot) {
        final reportedUserName = snapshot.data ?? '...';

        return Scaffold(
          appBar: AppBar(title: const Text('Report User')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: submitted,
                builder: (context, isSubmitted, _) {
                  if (isSubmitted) {
                    return const Center(
                      child: Text('Report submitted. Thank you!'),
                    );
                  }
                  return ValueListenableBuilder<String?>(
                    valueListenable: errorMessage,
                    builder: (context, error, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ValueListenableBuilder<String?>(
                            valueListenable: selectedReason,
                            builder: (context, reason, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: details,
                                builder: (context, detailsValue, _) {
                                  return ValueListenableBuilder<bool>(
                                    valueListenable: isLoading,
                                    builder: (context, loading, _) {
                                      return ReportForm(
                                        selectedReason: reason,
                                        details: detailsValue,
                                        isLoading: loading,
                                        reportedUserName: reportedUserName,
                                        reasons: const [
                                          'Inappropriate behavior',
                                          'Unsafe driving',
                                          'No-show',
                                          'Spam or scam',
                                          'Other',
                                        ],
                                        onReasonChanged: (val) {
                                          selectedReason.value = val;
                                        },
                                        onDetailsChanged: (val) {
                                          details.value = val;
                                        },
                                        onSubmit: () async {
                                          errorMessage.value = null;
                                          if (selectedReason.value == null ||
                                              selectedReason.value!.isEmpty) {
                                            errorMessage.value =
                                                'Please select a reason';
                                            return;
                                          }
                                          isLoading.value = true;
                                          await viewModel.submitReport(
                                            reporterId: '1',
                                            reportedUserId: reportedUserId,
                                            rideId: 'test_ride',
                                            reason: selectedReason.value!,
                                            details: details.value,
                                          );
                                          isLoading.value = false;
                                          submitted.value = true;
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
