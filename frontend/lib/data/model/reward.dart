import 'package:frontend/data/model.dart';

abstract class Reward implements Model {
  String get title;
  String get description;
  int get points;
}

// import 'package:frontend/data/model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'reward.g.dart';
// @JsonSerializable()
// class Reward extends Model {
//   final String name;
//   final String description;
//   final String code;
//   final int points;

//   const Reward({
//     required super.id,
//     required this.name,
//     required this.description,
//     required this.code,
//     required this.points,
//   });

//   factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

//   Map<String, dynamic> toJson() => _$RewardToJson(this);

//   factory Reward.random() {
//     return Reward(
//       id: DateTime.now().millisecondsSinceEpoch,
//       name: 'Reward ${DateTime.now().millisecondsSinceEpoch}',
//       description: 'Description ${DateTime.now().millisecondsSinceEpoch}',
//       code: 'Code ${DateTime.now().millisecondsSinceEpoch}',
//       points: DateTime.now().millisecondsSinceEpoch % 100,
//     );
//   }
// }
