import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/service/notification_service.dart';
import 'package:frontend/data/service/pickup_service.dart';
import 'package:frontend/ui/arrange_pickup/arrange_pickup_view.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_request_notification.dart';

class PickupNotificationHandler extends StatelessWidget {
  final NotificationService notificationService;
  final Widget child;

  const PickupNotificationHandler({
    super.key,
    required this.notificationService,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pickup>(
      stream: notificationService.notifications,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showPickupNotification(context, snapshot.data!);
          });
        }
        return child;
      },
    );
  }

  void _showPickupNotification(BuildContext context, Pickup pickup) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PickupRequestNotification(
            pickup: pickup,
            onArrange: () => _handleArrange(context, pickup),
            onDecline: () => _handleDecline(context, pickup),
          ),
    );
  }

  void _handleArrange(BuildContext context, Pickup pickup) {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      '/arrange_pickup',
      arguments: {
        'carpoolerId': pickup.carpoolerId,
        'driverId': pickup.driver.id,
        'ride': pickup.ride,
      },
    );
  }

  Future<void> _handleDecline(BuildContext context, Pickup pickup) async {
    final pickupService = PickupService();
    await pickupService.updatePickupStatus(
      pickupId: pickup.id,
      status: 'declined',
    );
    if (context.mounted) Navigator.pop(context);
  }
}
