// lib/ui/profile/points_widget.dart
import 'package:flutter/material.dart';
import 'profile_viewmodel.dart';

class PointsWidget extends StatelessWidget {
  final ProfileViewModel viewModel;

  const PointsWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel, // Listen to changes in ProfileViewModel
      builder: (context, _) {
        return Card(
          color: Colors.orange.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.stars, size: 32, color: Colors.orange.shade800),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Points',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${viewModel.points}', // Dynamically fetch points
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.orange.shade800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
