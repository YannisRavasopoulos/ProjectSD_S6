// lib/ui/profile/history_tab.dart
import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  final List<Map<String, String>> rides = const [
    {'from': 'Athens',   'to': 'Thessaloniki', 'date': '2025-04-12'},
    {'from': 'Patras',   'to': 'Athens',       'date': '2025-03-30'},
    {'from': 'Larisa',   'to': 'Volos',        'date': '2025-02-20'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (_, i) {
        final ride = rides[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text('${ride['from']} → ${ride['to']}'),
            subtitle: Text(ride['date']!),
          ),
        );
      },
    );
  }
}
