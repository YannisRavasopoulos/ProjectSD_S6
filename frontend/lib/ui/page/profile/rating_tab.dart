import 'package:flutter/material.dart';
import 'package:frontend/data/model/rating.dart';

class RatingTab extends StatelessWidget {
  const RatingTab({
    super.key,
    required this.ratings,
    required this.averageRating,
  });

  final List<Rating> ratings;
  final double averageRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Rating',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${averageRating.toStringAsFixed(1)}/5',
            style: Theme.of(context).textTheme.titleLarge,
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
          const SizedBox(height: 16),
          Expanded(child: _buildReviewsList()),
        ],
      ),
    );
  }

  Widget _buildAverageRating(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < averageRating.floor()
              ? Icons.star
              : (index < averageRating ? Icons.star_half : Icons.star_border),
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
        child: Text(rating.fromUser.firstName[0]), // Use first letter of name
      ),
      title: Text('${rating.fromUser.firstName} ${rating.fromUser.lastName}'),
      subtitle: rating.comment != null ? Text(rating.comment!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Icon(
            index < rating.stars ? Icons.star : Icons.star_border,
            size: 16,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
