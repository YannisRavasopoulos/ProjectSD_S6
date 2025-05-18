class Pickup {
  final String id;
  final String driverId;
  final String carpoolerId;
  final DateTime pickupTime;
  final String location;
  final String status;

  const Pickup({
    required this.id,
    required this.driverId,
    required this.carpoolerId,
    required this.pickupTime,
    required this.location,
    this.status = 'pending',
  });

  // pickup -> json
  Map<String, dynamic> toJson() => {
    'id': id,
    'driver_id': driverId,
    'carpooler_id': carpoolerId,
    'pickup_time': pickupTime.toIso8601String(),
    'location': location,
    'status': status,
  };

  // json -> pickup
  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    id: json['id'],
    driverId: json['driver_id'],
    carpoolerId: json['carpooler_id'],
    pickupTime: DateTime.parse(json['pickup_time']),
    location: json['location'],
    status: json['status'],
  );
}
