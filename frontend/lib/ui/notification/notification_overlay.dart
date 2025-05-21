import 'package:flutter/material.dart';

class NotificationOverlay {
  static OverlayEntry? _currentEntry;
  static AnimationController? _animationController;

  static void show(BuildContext context, Widget notification) {
    _currentEntry?.remove();
    _animationController?.dispose();

    _animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _currentEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: SlideTransition(position: animation, child: notification),
            ),
          ),
    );

    Overlay.of(context).insert(_currentEntry!);
    _animationController!.forward();
  }

  static Future<void> dismiss() async {
    if (_animationController == null || _currentEntry == null) return;

    await _animationController!.reverse();
    _currentEntry?.remove();
    _currentEntry = null;
    _animationController!.dispose();
    _animationController = null;
  }

  static bool get isShowing => _currentEntry != null;
}
