import 'package:flutter/material.dart';
import 'package:frontend/data/impl/impl_address_repository.dart';
import 'package:frontend/data/impl/impl_activity_repository.dart';
import 'package:frontend/data/model/activity.dart';
import 'package:frontend/ui/page/activities/activities_viewmodel.dart';
import 'package:latlong2/latlong.dart';

class CreateActivityView extends StatefulWidget {
  final ActivitiesViewModel viewModel;
  final Activity? activityToEdit; // Add this for editing

  const CreateActivityView({
    super.key,
    required this.viewModel,
    this.activityToEdit,
  });

  @override
  State<CreateActivityView> createState() => _CreateActivityViewState();
}

class _CreateActivityViewState extends State<CreateActivityView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  TimeOfDay _startTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.activityToEdit != null) {
      final activity = widget.activityToEdit!;
      _nameController.text = activity.name;

      _descriptionController.text = activity.description;
      _startLocationController.text = activity.startLocation.name;
      _endLocationController.text = activity.endLocation.name;
      _startTime = activity.startTime;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startLocationController.dispose();
    _endLocationController.dispose();
    super.dispose();
  }

  void _createOrUpdateActivity() async {
    if (_formKey.currentState!.validate()) {
      final startLocation = ImplLocation(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _startLocationController.text,
        coordinates: const LatLng(0, 0),
      );

      final endLocation = ImplLocation(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        name: _endLocationController.text,
        coordinates: const LatLng(0, 0),
      );

      try {
        if (widget.activityToEdit != null) {
          final updatedActivity = ImplActivity(
            id: widget.activityToEdit!.id,
            name: _nameController.text,
            description: _descriptionController.text,
            startTime: _startTime,
            startLocation: startLocation,
            endLocation: endLocation,
          );
          await widget.viewModel.updateActivity(updatedActivity);
        } else {
          final newActivity = ImplActivity(
            id: DateTime.now().millisecondsSinceEpoch + 2,
            name: _nameController.text,
            description: _descriptionController.text,
            startTime: _startTime,
            startLocation: startLocation,
            endLocation: endLocation,
          );
          await widget.viewModel.createActivity(newActivity);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Activity'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fill in the details below to create a new activity:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Activity Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an activity name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _startLocationController,
                decoration: const InputDecoration(
                  labelText: 'Start Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _endLocationController,
                decoration: const InputDecoration(
                  labelText: 'End Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _createOrUpdateActivity,
                  icon: const Icon(Icons.add),
                  label: Text(
                    widget.activityToEdit == null
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
        ),
      ),
    );
  }
}
