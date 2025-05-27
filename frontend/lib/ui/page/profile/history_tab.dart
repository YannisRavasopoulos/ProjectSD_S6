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
                        final ride = rides[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              // Show driver icon if user was the driver, else passenger icon
                              ride.driver.id == /* yourUserId */ 1
                                  ? Icons.drive_eta
                                  : Icons.person,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '${ride.route.start.name} → ${ride.route.end.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // Format date as you like
                                  '${ride.departureTime.day}/${ride.departureTime.month}/${ride.departureTime.year} at ${ride.departureTime.hour.toString().padLeft(2, '0')}:${ride.departureTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Driver: ${ride.driver.firstName} ${ride.driver.lastName}',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  // Example: distance and passengers
                                  '${ride.route is Route && ride.route.start != null && ride.route.end != null ? '' : ''}• ${ride.passengers.length} passengers',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
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



//OTAN BEI TO RIDE REPO KAI IMPL MODEL GIA TA PAST RIDES ADIKATHISTOUME ME TON PARAKATW KWDIKA
// ...existing code...

