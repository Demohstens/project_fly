import 'package:uuid/uuid.dart';

class Playist {
  final String name;
  String? description;
  String? imageUrl;
  List<Uuid> songIDs = [];

  Playist(
      {required this.name,
      this.description,
      this.imageUrl,
      required this.songIDs});

  factory Playist.fromJson(Map<String, dynamic> json) {
    return Playist(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      songIDs: json['songIDs'],
    );
  }
}
