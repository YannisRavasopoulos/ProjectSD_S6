import 'dart:async';
import 'package:frontend/data/model/pickup.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _notificationController = StreamController<Pickup>.broadcast();

  Stream<Pickup> get notifications => _notificationController.stream;

  void sendPickupRequest(Pickup pickup) {
    _notificationController.add(pickup);
  }

  void dispose() {
    _notificationController.close();
  }
}
