import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/ui/shared/address_selector.dart';

class TextAddressSelector extends StatefulWidget {
  final ValueChanged<Address> onAddressSelected;
  final AddressRepository addressRepository;
  final String labelText;
  final Address? initialAddress;

  const TextAddressSelector({
    super.key,
    required this.onAddressSelected,
    required this.addressRepository,
    required this.labelText,
    this.initialAddress,
  });

  @override
  State<TextAddressSelector> createState() => TextAddressSelectorState();
}

class TextAddressSelectorState extends State<TextAddressSelector> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO
    // _textController.dispose();
    super.dispose();
  }

  void setAddress(Address address) {
    setState(() {
      _textController.text = address.toString();
    });
  }

  Future<Address?> _showAddressSelector(BuildContext context) async {
    return showDialog<Address>(
      context: context,
      builder:
          (context) => Dialog(
            child: AddressSelector(
              addressRepository: widget.addressRepository,
              onAddressSelected: (address) {
                Navigator.of(context).pop(address);
              },
            ),
          ),
    );
  }

  void _onMapButtonPressed(BuildContext context) async {
    final address = await _showAddressSelector(context);
    if (address != null) {
      widget.onAddressSelected(address);
      setState(() {
        _textController.text = address.toString();
      });
    }
  }

  FutureOr<Iterable<Address>> _getSuggestions(
    TextEditingValue textEditingValue,
  ) async {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<Address>.empty();
    }

    // Fetch suggestions from the repository
    final results = await widget.addressRepository.fetchForQuery(
      textEditingValue.text,
    );

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Address>(
      optionsBuilder: _getSuggestions,
      displayStringForOption: (Address option) => option.toString(),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        _textController = controller;
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_pin),
            suffixIcon: IconButton(
              icon: Icon(Icons.map),
              onPressed: () => _onMapButtonPressed(context),
            ),
          ),
        );
      },
      onSelected: (Address address) {
        widget.onAddressSelected(address);
      },
    );
  }
}
