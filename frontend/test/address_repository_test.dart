import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/impl/impl_address_repository.dart';
import 'package:frontend/data/model/address.dart';
import 'package:frontend/data/model/user.dart';
import 'package:frontend/data/repository/address_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/data/impl/impl_user_repository.dart'; // <-- Import ImplUser

void main() {
  group('ImplAddressRepository', () {
    
    late AddressRepository addressRepository;
    
    setUp(() {
      addressRepository = ImplAddressRepository();
     
    });

    

    

    test('fetchForQuery returns addresses matching query', () async {
      final results = await addressRepository.fetchForQuery('castle');
      expect(results, isNotEmpty);
      expect(results.first.city, 'Patras');
      expect(results.first.street.toLowerCase(), contains('panachaiko'));
    });

    test('fetchForQuery returns empty list for nonsense query', () async {
      final results = await addressRepository.fetchForQuery('xyz');
      expect(results, isEmpty);
    });

    test('fetchForCoordinates returns addresses within 1km', () async {
      // Use coordinates close to Apollon Theatre
      final coords = LatLng(38.246629, 21.735501);
      final results = await addressRepository.fetchForCoordinates(coords);
      expect(results, isNotEmpty);
      // The closest should be Apollon Theatre
      expect(results.first.street, contains('Othonos-Amalias'));
    });

    test('fetchForCoordinates returns empty list for far coordinates', () async {
      // Coordinates far from Patras
      final coords = LatLng(0, 0);
      final results = await addressRepository.fetchForCoordinates(coords);
      expect(results, isEmpty);
    });
    test('fetchForQuery returns addresses matching query', () async {
      final results = await addressRepository.fetchForQuery('castle');
      expect(results, isNotEmpty);
      expect(results.first.city, 'Patras');
      expect(results.first.street.toLowerCase(), contains('panachaiko'));
  });
   

   
  });
}