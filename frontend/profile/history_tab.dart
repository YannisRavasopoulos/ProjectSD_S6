// lib/ui/profile/history_tab.dart
import 'package:flutter/material.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  // Static variables to persist state across instances
  static final List<Map<String, String>> _rides = [
    {'from': 'Athens', 'to': 'Thessaloniki', 'date': '2025-04-12'},
    {'from': 'Patras', 'to': 'Athens', 'date': '2025-03-30'},
    {'from': 'Larisa', 'to': 'Volos', 'date': '2025-02-20'},
  ];
  static bool _isCleared = false;

  void _clearHistory() {
    setState(() {
      _isCleared = true; // Mark history as cleared
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isCleared
                ? null // Disable button if history is already cleared
                : _clearHistory,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear History'),
          ),
        ),
        Expanded(
          child: _isCleared
              ? const Center(
                  child: Text(
                    'No history available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rides.length,
                  itemBuilder: (_, i) {
                    final ride = _rides[i];
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
