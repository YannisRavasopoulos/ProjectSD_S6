// lib/ui/profile/rating_tab.dart
import 'package:flutter/material.dart';

class RatingTab extends StatelessWidget {
  const RatingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviews = <Map<String, dynamic>>[
      {'user': 'Maria', 'stars': 5, 'comment': 'Great ride!'},
      {'user': 'John',  'stars': 4, 'comment': 'Comfortable and on time.'},
      {'user': 'Elena', 'stars': 5, 'comment': 'Very friendly driver.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Rating',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < 4 ? Icons.star : Icons.star_border,
                color: Colors.amber,
              );
            }),
          ),
          const SizedBox(height: 16),
          Text('Reviews',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final r = reviews[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(r['user'][0])),
                  title: Text(r['user']),
                  subtitle: Text(r['comment']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (j) => Icon(
                        j < r['stars'] ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
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
