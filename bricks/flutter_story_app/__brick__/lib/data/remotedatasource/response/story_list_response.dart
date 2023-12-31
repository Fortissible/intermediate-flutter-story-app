import 'dart:convert';
import '../../model/story_model.dart';

class StoryListResponse {
  bool error;
  String message;
  List<StoryModel> listStory;

  StoryListResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryListResponse.fromRawJson(String str) =>
      StoryListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoryListResponse.fromJson(Map<String, dynamic> json) => StoryListResponse(
    error: json["error"],
    message: json["message"],
    listStory: List<StoryModel>.from(json["listStory"]
        .map(
            (x) =>
            StoryModel.fromJson(x)
    )
    ),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "listStory": List<dynamic>.from(
        listStory.map((x) => x.toJson())
    ),
  };
}