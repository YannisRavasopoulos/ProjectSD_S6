class Report {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final String rideId;
  final String reason;
  final String details;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.rideId,
    required this.reason,
    required this.details,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reporterId': reporterId,
        'reportedUserId': reportedUserId,
        'rideId': rideId,
        'reason': reason,
        'details': details,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'],
        reporterId: json['reporterId'],
        reportedUserId: json['reportedUserId'],
        rideId: json['rideId'],
        reason: json['reason'],
        details: json['details'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}