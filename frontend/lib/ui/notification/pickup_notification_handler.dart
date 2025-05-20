import 'package:flutter/material.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/repository/driver_repository.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/service/notification_service.dart';
import 'package:frontend/ui/arrange_pickup/components/pickup_request_notification.dart';

class PickupNotificationHandler extends StatelessWidget {
  final NotificationService notificationService;
  final DriverRepository driverRepository;
  final RideRepository rideRepository;
  final Widget child;

  const PickupNotificationHandler({
    super.key,
    required this.notificationService,
    required this.driverRepository,
    required this.rideRepository,
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
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PickupRequestNotification(pickup: pickup),
    ).then((accepted) {
      if (accepted == true) {
        _handleArrange(context, pickup);
      } else if (accepted == false) {
        // _handleDecline(context, pickup);
      }
    });
  }

  void _handleArrange(BuildContext context, Pickup pickup) async {
    try {
      final driver = await driverRepository.getDriver(pickup.driverID);
      final ride = await rideRepository.getRide(pickup.rideID);

      if (!context.mounted) return;

      Navigator.of(context).pushNamed(
        '/arrange_pickup',
        arguments: {
          'carpoolerId': pickup.carpoolerId,
          'driver': driver,
          'selectedRide': ride,
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load pickup details: $e')),
      );
    }
  }
}
