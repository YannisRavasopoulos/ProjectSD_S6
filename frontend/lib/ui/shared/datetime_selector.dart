import 'package:flutter/material.dart';
import 'package:frontend/convert.dart';

class DateTimeSelector extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final ValueChanged<DateTime?> onDateTimeSelected;
  final DateTime Function(String) optionsToDateTime;

  const DateTimeSelector({
    super.key,
    required this.labelText,
    required this.options,
    required this.onDateTimeSelected,
    required this.optionsToDateTime,
  });

  @override
  State<DateTimeSelector> createState() => DateTimeSelectorState();
}

class DateTimeSelectorState extends State<DateTimeSelector> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onDropdownSelected(BuildContext context, String value) async {
    if (value != "Select") {
      var dateTime = widget.optionsToDateTime(value);
      _textController.text = dateTime.toString();
      widget.onDateTimeSelected(dateTime);
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      var time = Convert.timeOfDayToDateTime(pickedTime);
      _textController.text = time.toString();
      widget.onDateTimeSelected(time);
    } else {
      // Set to unselected if no time is picked
      _textController.text = "";
      widget.onDateTimeSelected(null);
      return;
    }
  }

  void setDateTime(DateTime value) {
    _textController.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      label: Text(widget.labelText),
      expandedInsets: EdgeInsets.all(0),
      controller: _textController,
      dropdownMenuEntries:
          widget.options
              .map((option) => DropdownMenuEntry(value: option, label: option))
              .toList(),
      requestFocusOnTap: false,
      onSelected: (value) => _onDropdownSelected(context, value!),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
