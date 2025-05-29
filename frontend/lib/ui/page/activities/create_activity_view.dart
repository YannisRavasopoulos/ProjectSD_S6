import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/page/activities/create_activity_viewmodel.dart';

class CreateActivityView extends StatelessWidget {
  final CreateActivityViewModel viewModel;

  const CreateActivityView({super.key, required this.viewModel});

  void _onCreateOrUpdateActivityPressed(BuildContext context) async {
    bool success = false;

    if (viewModel.activity == null) {
      success = await viewModel.createActivity();
    } else {
      success = await viewModel.editActivity();
    }

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.activity == null
                ? 'Activity created successfully!'
                : 'Activity updated successfully!',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Activity'), centerTitle: true),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildForm(context);
          }
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fill in the details below to create a new activity:',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: viewModel.nameController,
            decoration: const InputDecoration(
              labelText: 'Activity Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: viewModel.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          // TODO: Add address picker
          const SizedBox(height: 16.0),
          ListTile(
            title: const Text('Select Time'),
            subtitle: Text(
              viewModel.timeOfDay == null
                  ? 'No time selected'
                  : viewModel.timeOfDay!.format(context),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.access_time),
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: viewModel.timeOfDay ?? TimeOfDay.now(),
                );
                if (time != null) {
                  viewModel.selectTimeOfDay(time);
                }
              },
            ),
          ),
          const SizedBox(height: 32.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _onCreateOrUpdateActivityPressed(context),
              icon: const Icon(Icons.add),
              label: Text(
                viewModel.activity == null
                    ? 'Create Activity'
                    : 'Update Activity',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
