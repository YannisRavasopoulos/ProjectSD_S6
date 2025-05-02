import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget child;
  final ButtonStyle? style;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style:
          style ??
          FilledButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          ),
      child: SizedBox(
        height: 24, // Fixed height for both CircularProgressIndicator and Text
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : child,
        ),
      ),
    );
  }
}
