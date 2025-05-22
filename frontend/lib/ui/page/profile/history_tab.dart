// lib/ui/profile/history_tab.dart
import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
    required this.onClearHistory,
    required this.rides,
  });

  final VoidCallback onClearHistory;
  final List<Ride> rides;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
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
          const SizedBox(height: 8),
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
                      itemCount: rides.length,
                      itemBuilder: (_, i) {
                        // final ride = rides[i];
                        return Card(
                          // margin: const EdgeInsets.symmetric(vertical: 8),
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
      ),
    );
  }
}
