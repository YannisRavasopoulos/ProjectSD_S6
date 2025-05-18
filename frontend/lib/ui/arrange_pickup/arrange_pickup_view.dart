import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';
import 'package:frontend/ui/arrange_pickup/arrange_pickup_viewmodel.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_form.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/ui/arrange_pickup/components/ride_details_panel.dart';

class ArrangePickupView extends StatefulWidget {
  final String carpoolerId;
  final String driverId;
  final Ride selectedRide;

  const ArrangePickupView({
    super.key,
    required this.carpoolerId,
    required this.driverId,
    required this.selectedRide,
  });

  @override
  State<ArrangePickupView> createState() => _ArrangePickupViewState();
}

class _ArrangePickupViewState extends State<ArrangePickupView> {
  late final ArrangePickupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ArrangePickupViewModel(
      repository: PickupRepository(pickupService: PickupService()),
      driverId: widget.driverId,
      rideId: widget.selectedRide.id,
    )..addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SharedLayout(
      currentIndex: 0,
      isIndexed: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Arrange Pickup Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              RideDetailsPanel(ride: widget.selectedRide),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Pickup Details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      if (_viewModel.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        PickupForm(
                          selectedTime: _viewModel.selectedTime,
                          location: _viewModel.location,
                          onTimeSelected: _viewModel.setPickupTime,
                          onLocationChanged: _viewModel.setLocation,
                          onSubmit: _handleSubmit,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Send Pickup Proposal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_viewModel.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Invalid pickup details'),
        ),
      );
      return;
    }

    final success = await _viewModel.arrangePickup(
      carpoolerId: widget.carpoolerId,
      driverId: widget.driverId,
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup proposal sent successfully')),
      );
      Navigator.pop(context);
    } else if (_viewModel.errorMessage != null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(_viewModel.errorMessage!),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
