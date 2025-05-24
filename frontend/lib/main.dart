import 'package:flutter/material.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';
import 'package:frontend/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // setWindowTitle('Loop App');
    var size = const Size(500, 800);
    setWindowMaxSize(size);
    setWindowMinSize(size);
  }

  runApp(App());
}
