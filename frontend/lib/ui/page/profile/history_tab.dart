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
                      itemCount: 5, // Hardcoded number of sample rides
                      itemBuilder: (_, i) {
                        // Hardcoded sample rides
                        final List<Map<String, dynamic>> sampleRides = [
                          {
                            'from': 'University',
                            'to': 'City Center',
                            'date': '25/05/2024 at 14:30',
                            'distance': 5.2,
                            'passengers': 3,
                            'isDriver': true,
                          },
                          {
                            'from': 'Shopping Mall',
                            'to': 'Train Station',
                            'date': '22/05/2024 at 09:15',
                            'distance': 8.7,
                            'passengers': 2,
                            'isDriver': false,
                          },
                          {
                            'from': 'Airport',
                            'to': 'University Campus',
                            'date': '20/05/2024 at 11:45',
                            'distance': 15.3,
                            'passengers': 4,
                            'isDriver': true,
                          },
                          {
                            'from': 'Library',
                            'to': 'Sports Center',
                            'date': '18/05/2024 at 16:20',
                            'distance': 3.1,
                            'passengers': 1,
                            'isDriver': false,
                          },
                          {
                            'from': 'Student Housing',
                            'to': 'City Park',
                            'date': '15/05/2024 at 13:00',
                            'distance': 4.8,
                            'passengers': 2,
                            'isDriver': true,
                          },
                        ];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              sampleRides[i]['isDriver'] ? Icons.drive_eta : Icons.person,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '${sampleRides[i]['from']} → ${sampleRides[i]['to']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sampleRides[i]['date'],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  '${sampleRides[i]['distance']}km • ${sampleRides[i]['passengers']} passengers',
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
// itemBuilder: (_, i) {
//   final ride = rides[i];
//   return Card(
//     child: ListTile(
//       leading: const Icon(Icons.directions_car),
//       title: Text(
//         '${ride.from} → ${ride.to}',
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${ride.date.day}/${ride.date.month}/${ride.date.year} at ${ride.date.hour}:${ride.date.minute}',
//             style: const TextStyle(color: Colors.grey),
//           ),
//           Text(
//             '${ride.distance}km • ${ride.price}€ • ${ride.passengers} passengers',
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//       trailing: Icon(
//         ride.isDriver ? Icons.drive_eta : Icons.person,
//         color: Colors.blue,
//       ),
//     ),
//   );
// },
// ...existing code...