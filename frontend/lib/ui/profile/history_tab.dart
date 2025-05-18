// lib/ui/profile/history_tab.dart
import 'package:flutter/material.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<Map<String, String>> rides = [
    {'from': 'Athens', 'to': 'Thessaloniki', 'date': '2025-04-12'},
    {'from': 'Patras', 'to': 'Athens', 'date': '2025-03-30'},
    {'from': 'Larisa', 'to': 'Volos', 'date': '2025-02-20'},
  ];

  void _clearHistory() {
    setState(() {
      rides.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: rides.isEmpty
                ? null // Disable button if history is already empty
                : _clearHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear History'),
          ),
        ),
        Expanded(
          child: rides.isEmpty
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
                        title: Text('${ride['from']} → ${ride['to']}'),
                        subtitle: Text(ride['date']!),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
