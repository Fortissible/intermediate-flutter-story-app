import 'dart:convert';

import 'package:{{appName.snakeCase()}}/domain/entity/story_detail_entity.dart';

class StoryDetailModel {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  StoryDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory StoryDetailModel.fromRawJson(String str) => StoryDetailModel
      .fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoryDetailModel.fromJson(Map<String, dynamic> json) =>
      StoryDetailModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  StoryDetailEntity modelToEntity() => StoryDetailEntity(
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