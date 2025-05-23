import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/ui/page/rating/rate_viewmodel.dart';

class RateView extends StatelessWidget {
  final User toUser;
  final RateViewModel viewModel;

  const RateView({super.key, required this.toUser, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingTitle(context),
            const SizedBox(height: 24),
            _buildRatingBar(),
            const SizedBox(height: 32),
            _buildCommentTitle(context),
            const SizedBox(height: 8),
            _buildCommentField(),
            const SizedBox(height: 24),
            _buildErrorMessage(context),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Rate ${toUser.name}'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildRatingTitle(BuildContext context) {
    return Text(
      'How would you rate your experience?',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildRatingBar() {
    return Center(
      child: RatingBar.builder(
        initialRating: viewModel.rating.toDouble(),
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder:
            (context, _) => const Icon(Icons.star, color: Colors.amber),
        onRatingUpdate: viewModel.setRating,
      ),
    );
  }

  Widget _buildCommentTitle(BuildContext context) {
    return Text(
      'Add a comment (optional)',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildCommentField() {
    return TextField(
      onChanged: viewModel.setComment,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Share your experience...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    if (viewModel.errorMessage.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        viewModel.errorMessage,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder:
          (context, _) => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  viewModel.canSubmit
                      ? () => viewModel.submitRating(toUser)
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _buildSubmitButtonChild(),
            ),
          ),
    );
  }

  Widget _buildSubmitButtonChild() {
    return viewModel.isLoading
        ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
        : const Text('Submit Rating', style: TextStyle(fontSize: 16));
  }
}
