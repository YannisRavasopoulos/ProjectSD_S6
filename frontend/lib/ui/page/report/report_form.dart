import 'package:flutter/material.dart';

class ReportForm extends StatelessWidget {
  final String? selectedReason;
  final String details;
  final bool isLoading;
  final String reportedUserName;
  final List<String> reasons;
  final void Function(String?) onReasonChanged;
  final void Function(String) onDetailsChanged;
  final VoidCallback onSubmit;

  const ReportForm({
    super.key,
    required this.selectedReason,
    required this.details,
    required this.isLoading,
    required this.reportedUserName,
    required this.reasons,
    required this.onReasonChanged,
    required this.onDetailsChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Report User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 23, 143, 117),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reporting: $reportedUserName',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items: reasons
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              value: selectedReason,
              onChanged: onReasonChanged,
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Please select a reason' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Details (optional)',
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 4,
              onChanged: onDetailsChanged,
              initialValue: details,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 23, 143, 117),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Submit Report'),
                onPressed: isLoading ? null : onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}