class Pickup {
  final String id;
  final String rideID;
  final String driverID;
  final String carpoolerId;
  final DateTime pickupTime;
  final String location;
  final String status;

  const Pickup({
    required this.id,
    required this.rideID,
    required this.driverID,
    required this.carpoolerId,
    required this.pickupTime,
    required this.location,
    this.status = 'pending',
  });

  // json -> pickup
  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    id: json['id'],
    driverID: json['driver_id'],
    rideID: json['ride_id'],
    carpoolerId: json['carpooler_id'],
    pickupTime: DateTime.parse(json['pickup_time']),
    location: json['location'],
    status: json['status'] ?? 'pending',
  );

  // pickup -> json
  Map<String, dynamic> toJson() => {
    'id': id,
    'driver_id': driverID,
    'ride_id': rideID,
    'carpooler_id': carpoolerId,
    'pickup_time': pickupTime.toIso8601String(),
    'location': location,
    'status': status,
  };
}
