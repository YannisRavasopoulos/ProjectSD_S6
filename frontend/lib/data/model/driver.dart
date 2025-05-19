import 'dart:math';

class Driver {
  final String id;
  final String name;
  final String? photoUrl;
  final double rating;

  const Driver({
    required this.id,
    required this.name,
    this.photoUrl,
    this.rating = 0.0,
  });

  factory Driver.random() {
    final random = Random();
    final names = ["John Doe", "Jane Smith", "Mike Johnson", "Sarah Williams"];

    return Driver(
      id: random.nextInt(10000).toString(),
      name: names[random.nextInt(names.length)],
      rating:
          (random.nextInt(50) + 1) / 10, // Random rating between 0.1 and 5.0
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      photoUrl: json['photo_url'],
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'photo_url': photoUrl, 'rating': rating};
  }
}
