import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';

class RatingTab extends StatelessWidget {
  const RatingTab({
    super.key,
    required this.ratings,
    required this.averageRating,
  });

  final List<Rating> ratings;
  final int averageRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Rating',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildAverageRating(context),
          const SizedBox(height: 16),
          Text(
            'Reviews',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildReviewsList()),
        ],
      ),
    );
  }

  Widget _buildAverageRating(BuildContext context) {
    print('Average Rating: $averageRating');
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < averageRating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _buildReviewsList() {
    return ListView.separated(
      itemCount: ratings.length,

      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return _buildRatingItem(context, rating);
      },
    );
  }

  Widget _buildRatingItem(BuildContext context, Rating rating) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(rating.fromUserId.toString()[0].toUpperCase()),
      ),
      title: Text('User ${rating.fromUserId}'),
      subtitle: rating.comment != null ? Text(rating.comment!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Icon(
            index < rating.score ? Icons.star : Icons.star_border,
            size: 16,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
