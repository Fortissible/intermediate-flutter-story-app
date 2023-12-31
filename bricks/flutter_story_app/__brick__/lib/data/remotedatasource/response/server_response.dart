import 'dart:convert';

class ServerResponse {
  bool error;
  String message;

  ServerResponse({
    required this.error,
    required this.message,
  });

  factory ServerResponse.fromRawJson(String str) => ServerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}