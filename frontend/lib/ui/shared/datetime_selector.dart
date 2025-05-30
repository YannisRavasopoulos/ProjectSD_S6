import 'package:flutter/material.dart';

class DateTimeSelector extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final List<String> options;
  final ValueChanged<DateTime?> onDateTimeSelected;
  final DateTime Function(String) optionsToDateTime;

  const DateTimeSelector({
    super.key,
    required this.controller,
    required this.labelText,
    required this.options,
    required this.onDateTimeSelected,
    required this.optionsToDateTime,
  });

  @override
  State<DateTimeSelector> createState() => DateTimeSelectorState();
}

class DateTimeSelectorState extends State<DateTimeSelector> {
  @override
  void initState() {
    super.initState();
  }

  void _onDropdownSelected(BuildContext context, String value) async {
    if (value != "Select") {
      var dateTime = widget.optionsToDateTime(value);
      widget.controller.text = dateTime.toString();
      widget.onDateTimeSelected(dateTime);
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      widget.controller.text = pickedTime.format(context);
      widget.onDateTimeSelected(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );
    } else {
      // Set to unselected if no time is picked
      widget.controller.text = "";
      widget.onDateTimeSelected(null);
      return;
    }
  }

  void setDateTime(DateTime value) {
    widget.controller.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      label: Text(widget.labelText),
      expandedInsets: EdgeInsets.all(0),
      controller: widget.controller,
      dropdownMenuEntries:
          widget.options
              .map((option) => DropdownMenuEntry(value: option, label: option))
              .toList(),
      requestFocusOnTap: false,
      onSelected: (value) => _onDropdownSelected(context, value!),
    );
  }
}
