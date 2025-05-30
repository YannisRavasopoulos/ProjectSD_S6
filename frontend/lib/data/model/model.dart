abstract class Model {
  final int id;
  final DateTime createdAt = DateTime.now();

  Model({required this.id});
}
