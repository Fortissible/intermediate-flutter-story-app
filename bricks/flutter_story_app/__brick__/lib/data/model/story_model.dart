import 'dart:convert';

import 'package:{{appName.snakeCase()}}/domain/entity/story_entity.dart';

class StoryModel {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  StoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon
  });

  factory StoryModel.fromRawJson(String str) => StoryModel
      .fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      StoryModel(
          id: json["id"],
          name: json["name"],
          description: json["description"],
          photoUrl: json["photoUrl"],
          createdAt: DateTime.parse(json["createdAt"]),
          lat: json["lat"],
          lon: json["lon"]
      );

  StoryEntity modelToEntity() => StoryEntity(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lat: lat,
      lon: lon
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };
}