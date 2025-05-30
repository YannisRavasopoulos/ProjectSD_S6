import 'package:flutter/material.dart';
import 'package:frontend/data/model/report_reason.dart';
import 'package:frontend/ui/shared/loading_button.dart';
import 'report_viewmodel.dart';

class ReportView extends StatelessWidget {
  final ReportViewModel viewModel;

  const ReportView({super.key, required this.viewModel});

  void _onSubmitPressed(BuildContext context) async {
    bool success = await viewModel.submitReport();
    if (success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Unknown error')),
      );
    }
  }

  void _onReportReasonSelected(ReportReason? reason) {
    if (reason != null) {
      viewModel.selectReason(reason);
    }
  }

  String _reasonToString(ReportReason reason) {
    switch (reason) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.inappropriateBehavior:
        return 'Inappropriate Behavior';
      case ReportReason.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report User'),
        backgroundColor: Colors.redAccent,
        elevation: 2,
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reporting: ${viewModel.reported.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Icon(
                      Icons.report_problem,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Why are you reporting this user?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<ReportReason>(
                      value: viewModel.reason,
                      decoration: const InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items:
                          ReportReason.values
                              .map(
                                (reason) => DropdownMenuItem(
                                  value: reason,
                                  child: Text(_reasonToString(reason)),
                                ),
                              )
                              .toList(),
                      onChanged:
                          viewModel.isSubmitting
                              ? null
                              : _onReportReasonSelected,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: viewModel.descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      enabled: !viewModel.isSubmitting,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      child: LoadingButton(
                        isLoading: viewModel.isSubmitting,
                        onPressed:
                            viewModel.canSubmit
                                ? () => _onSubmitPressed(context)
                                : null,
                        child: Text('Submit Report'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
