import 'package:frontend/data/impl/impl_location_repository.dart';
import 'package:frontend/data/model/location.dart';
import 'package:frontend/data/model/route.dart';

class ImplRoute implements Route {
  @override
  final int id;
  @override
  final Location start;
  @override
  final Location end;

  const ImplRoute({required this.id, required this.start, required this.end});

  factory ImplRoute.test() {
    return ImplRoute(
      id: 1,
      start: ImplLocation.test('start'),
      end: ImplLocation.test('end'),
    );
  }
}
