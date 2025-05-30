import 'package:flutter/material.dart';
import 'package:frontend/data/model/ride.dart';
import 'package:frontend/data/repository/ride_repository.dart';
import 'package:frontend/data/repository/rating_repository.dart';
import 'package:frontend/data/repository/report_repository.dart';

class RideEndedViewModel extends ChangeNotifier {
  final RideRepository rideRepository;
  final RatingRepository ratingRepository;
  final ReportRepository reportRepository;
  final Ride ride;

  RideEndedViewModel({
    required this.rideRepository,
    required this.ratingRepository,
    required this.reportRepository,
    required this.ride,
  });
}
