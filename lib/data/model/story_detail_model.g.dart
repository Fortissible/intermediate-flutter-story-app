// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetailModel _$StoryDetailModelFromJson(Map<String, dynamic> json) =>
    StoryDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StoryDetailModelToJson(StoryDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
