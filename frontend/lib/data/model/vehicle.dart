import 'dart:math';

class Vehicle {
  final String id;
  final String make;
  final String model;
  final String color;
  final String plateNumber;
  final int year;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.color,
    required this.plateNumber,
    required this.year,
  });

  String get description => '$year $color $make $model';

  factory Vehicle.random() {
    final random = Random();
    final makes = ["Toyota", "Honda", "Ford", "BMW"];
    final models = ["Camry", "Civic", "Focus", "3 Series"];
    final colors = ["Black", "White", "Silver", "Blue"];

    return Vehicle(
      id: random.nextInt(10000).toString(),
      make: makes[random.nextInt(makes.length)],
      model: models[random.nextInt(models.length)],
      color: colors[random.nextInt(colors.length)],
      plateNumber: "ABC${random.nextInt(999)}",
      year: 2020 + random.nextInt(5),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      color: json['color'],
      plateNumber: json['plate_number'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'color': color,
      'plate_number': plateNumber,
      'year': year,
    };
  }
}
