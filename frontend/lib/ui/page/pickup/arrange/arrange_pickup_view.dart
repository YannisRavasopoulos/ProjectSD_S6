import 'package:flutter/material.dart';
import 'package:frontend/convert.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/ui/page/pickup/arrange/arrange_pickup_viewmodel.dart';
import 'package:frontend/ui/shared/address_selector.dart';

class ArrangePickupView extends StatelessWidget {
  final ArrangePickupViewModel viewModel;

  const ArrangePickupView({super.key, required this.viewModel});

  void _onAddressSelected(Address address) {
    viewModel.selectAddress(address);
  }

  void _onArrangePickupPressed(BuildContext context) async {
    bool success = await viewModel.arrangePickup();
    if (success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup arranged successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to arrange pickup.')),
      );
    }
  }

  void _onPickupTimePressed(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      viewModel.selectTime(Convert.timeOfDayToDateTime(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Arrange Pickup')),
          body: Column(
            children: [
              SizedBox(
                height: 300,
                child: AddressSelector(
                  addressRepository: viewModel.addressRepository,
                  onAddressSelected: _onAddressSelected,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  viewModel.selectedTime != null
                      ? 'Pickup Time: ${viewModel.selectedTime.toString()}'
                      : 'Select Pickup Time',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _onPickupTimePressed(context),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    viewModel.canArrangePickup
                        ? () => _onArrangePickupPressed(context)
                        : null,
                child: const Text('Arrange Pickup'),
              ),
            ],
          ),
        );
      },
    );
  }
}
