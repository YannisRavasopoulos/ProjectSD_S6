import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/ui/page/rate/rate_viewmodel.dart';

class RateView extends StatelessWidget {
  final RateViewModel viewModel;

  const RateView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, viewModel.rated),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingTitle(),
            const SizedBox(height: 24),
            _buildRatingBar(viewModel.rating.toDouble(), viewModel.setRating),
            const SizedBox(height: 32),
            _buildCommentTitle(),
            const SizedBox(height: 8),
            _buildCommentField(viewModel.setComment),
            const SizedBox(height: 24),
            _buildErrorMessage(viewModel.errorMessage, context),
            _buildSubmitButton(context, viewModel.rated),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, User toUser) {
    return AppBar(
      title: Text('Rate ${toUser.name}'),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildRatingTitle() {
    return const Text(
      'How would you rate your experience?',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRatingBar(
    double initialRating,
    Function(double) onRatingUpdate,
  ) {
    return Center(
      child: RatingBar.builder(
        initialRating: initialRating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder:
            (context, _) => const Icon(Icons.star, color: Colors.amber),
        onRatingUpdate: onRatingUpdate,
      ),
    );
  }

  Widget _buildCommentTitle() {
    return const Text(
      'Add a comment (optional)',
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildCommentField(Function(String) onCommentChanged) {
    return TextField(
      onChanged: onCommentChanged,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Share your experience...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildErrorMessage(String errorMessage, BuildContext context) {
    if (errorMessage.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        errorMessage,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, User toUser) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Success'),
                  content: const Text(
                    'Your rating has been submitted successfully.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(
                          context,
                        ).pop(); // Return to previous screen
                      },
                    ),
                  ],
                );
              },
            );
          });
        }

        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed:
                viewModel.canSubmit
                    ? () => viewModel.submitRating(toUser)
                    : null,
            child:
                viewModel.isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Submit Rating',
                      style: TextStyle(fontSize: 16),
                    ),
          ),
        );
      },
    );
  }
}
