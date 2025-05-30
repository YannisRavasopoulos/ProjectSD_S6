class Vehicle {
  final int id;
  final String description;
  final int capacity;

  const Vehicle({
    required this.id,
    required this.description,
    required this.capacity,
  });

  factory Vehicle.test() {
    return const Vehicle(id: 1, description: 'Test Vehicle', capacity: 4);
  }
}
