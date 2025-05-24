import 'package:flutter/material.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';
import 'package:frontend/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // setWindowTitle('Loop App');
    setWindowFrame(
      const Rect.fromLTWH(300, 500, 600, 900),
    ); // Default size and position
  }

  runApp(App());
}
