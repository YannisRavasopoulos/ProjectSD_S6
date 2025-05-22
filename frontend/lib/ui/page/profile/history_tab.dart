// lib/ui/profile/history_tab.dart
import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
    required VoidCallback this.onClearHistory,
    required List<Ride> this.rides,
  });

  final VoidCallback onClearHistory;
  final List<Ride> rides;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed:
                rides.isEmpty
                    ? null // Disable button if history is already cleared
                    : onClearHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear History'),
          ),
        ),
        Expanded(
          child:
              rides.isEmpty
                  ? const Center(
                    child: Text(
                      'No history available.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rides.length,
                    itemBuilder: (_, i) {
                      final ride = rides[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text("RIDE DESCRIPTION"),
                          subtitle: Text("TODO"),
                          // TODO
                          // title: Text(
                          //   '${ride.from} to ${ride.to}',
                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // subtitle: Text(
                          //   ride.date,
                          //   style: const TextStyle(color: Colors.grey),
                          // ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
