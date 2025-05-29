import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget child;
  final ButtonStyle? style;

  const LoadingButton({
    super.key,
    this.onPressed,
    required this.isLoading,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
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
