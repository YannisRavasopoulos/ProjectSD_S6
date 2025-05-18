import 'package:flutter/material.dart';
import 'package:frontend/ui/shared_layout.dart';
import 'package:frontend/ui/arrange_pickup/arrange_pickup_viewmodel.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_form.dart';
import 'package:frontend/data/repository/pickup_repository.dart';
import 'package:frontend/data/service/pickup_service.dart';

class ArrangePickupView extends StatefulWidget {
  final String carpoolerId;
  final String driverId;

  const ArrangePickupView({
    super.key,
    required this.carpoolerId,
    required this.driverId,
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

  Widget build(BuildContext context) {
    return SharedLayout(
      currentIndex: 0,
      isIndexed: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_viewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              PickupForm(
                selectedTime: _viewModel.selectedTime,
                location: _viewModel.location,
                onTimeSelected: _viewModel.setPickupTime,
                onLocationChanged: _viewModel.setLocation,
                onSubmit: () async {
                  final success = await _viewModel.arrangePickup(
                    carpoolerId: widget.carpoolerId,
                    driverId: widget.driverId,
                  );
                  if (success) {
                    Navigator.pop(context);
                  }
                },
              ),
            if (_viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
