import 'package:flutter/widgets.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/pickup.dart';
import 'package:frontend/data/model/pickup_request.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:frontend/data/repository/pickup_repository.dart';

class ArrangePickupViewModel extends ChangeNotifier {
  ArrangePickupViewModel({
    required this.addressRepository,
    required this.pickupRepository,
    required this.pickupRequest,
  });

  final PickupRequest pickupRequest;
  final AddressRepository addressRepository;
  final PickupRepository pickupRepository;
  bool get canArrangePickup => selectedAddress != null && selectedTime != null;

  Address? selectedAddress;
  DateTime? selectedTime;

  Future<bool> arrangePickup() async {
    if (selectedAddress == null || selectedTime == null) {
      return false;
    }

    // TODO
    try {
      var pickup = Pickup(
        id: 0,
        ride: pickupRequest.ride,
        passenger: pickupRequest.passenger,
        time: selectedTime!,
        address: selectedAddress!,
      );
      await pickupRepository.acceptPickupRequest(pickupRequest, pickup);
      return true;
    } catch (e) {
      return false;
    }
  }

  void selectAddress(Address address) {
    selectedAddress = address;
    notifyListeners();
  }

  void selectTime(DateTime time) {
    selectedTime = time;
    notifyListeners();
  }
}
