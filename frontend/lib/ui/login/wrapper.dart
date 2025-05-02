import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final Widget? child;

  const Wrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(32.0),
      child: SingleChildScrollView(child: child),
    );
  }
}
