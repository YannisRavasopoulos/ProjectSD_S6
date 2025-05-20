import 'package:flutter/material.dart';

class NotificationOverlay {
  static void show(BuildContext context, Widget notification) {
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: AnimationController(
                      vsync: Navigator.of(context),
                      duration: const Duration(milliseconds: 300),
                    )..forward(),
                    curve: Curves.easeOut,
                  ),
                ),
                child: notification,
              ),
            ),
          ),
    );

    Overlay.of(context).insert(entry);

    Future.delayed(const Duration(seconds: 4), () {
      entry?.remove();
    });
  }
}
