import 'package:flutter/material.dart';

abstract final class Convert {
  static DateTime timeOfDayToDateTime(TimeOfDay time) {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );
  }
}
