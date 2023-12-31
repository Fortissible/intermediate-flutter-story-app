import 'dart:convert';

import 'package:intermediate_flutter_story_app/data/model/story_detail_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'story_detail_response.g.dart';

@JsonSerializable()
class StoryDetailResponse {
  bool error;
  String message;
  StoryDetailModel story;

  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  // factory StoryDetailResponse.fromRawJson(String str) => StoryDetailResponse.fromJson(json.decode(str));
  //
  // String toRawJson() => json.encode(toJson());

  // factory StoryDetailResponse.fromJson(Map<String, dynamic> json) => StoryDetailResponse(
  //   error: json["error"],
  //   message: json["message"],
  //   story: StoryDetailModel.fromJson(json["story"]),
  // );

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) => _$StoryDetailResponseFromJson(json);

  // Map<String, dynamic> toJson() => {
  //   "error": error,
  //   "message": message,
  //   "story": story.toJson(),
  // };

  Map<String, dynamic> toJson() => _$StoryDetailResponseToJson(this);
}
