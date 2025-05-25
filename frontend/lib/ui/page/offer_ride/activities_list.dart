import 'package:flutter/material.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';

class ActivitiesList extends StatelessWidget {
  final ActivitiesViewModel viewModel;
  final Future<List<String>> Function(String id) fetchCarpoolers;

  const ActivitiesList({
    super.key,
    required this.viewModel,
    required this.fetchCarpoolers,
  });

  @override
  Widget build(BuildContext context) {
    final activities = viewModel.activities ?? [];
    if (activities.isEmpty) {
      return const Center(
        child: Text(
          'No activities found.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.orange.shade200,
              child: const Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              activity.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              '${activity.location.name} - ${activity.time.format(context)}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orange),
            onTap: () async {
              final carpoolers = await fetchCarpoolers(activity.id.toString());
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text('Nearby Carpoolers for "${activity.name}"'),
                      content:
                          carpoolers.isEmpty
                              ? const Text('No carpoolers found.')
                              : Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    carpoolers
                                        .map(
                                          (c) => ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(c),
                                          ),
                                        )
                                        .toList(),
                              ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
