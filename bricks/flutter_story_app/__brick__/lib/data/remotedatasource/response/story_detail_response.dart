import 'dart:convert';

import 'package:{{appName.snakeCase()}}/data/model/story_detail_model.dart';

class StoryDetailResponse {
  bool error;
  String message;
  StoryDetailModel story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetailResponse.fromRawJson(String str) => StoryDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) => StoryDetailResponse(
    error: json["error"],
    message: json["message"],
    story: StoryDetailModel.fromJson(json["story"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "story": story.toJson(),
  };
}