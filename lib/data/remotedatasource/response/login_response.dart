import 'dart:convert';

import 'package:intermediate_flutter_story_app/data/model/login_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  bool error;
  String message;
  LoginModel loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  // factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));
  //
  // String toRawJson() => json.encode(toJson());

  // factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
  //   error: json["error"],
  //   message: json["message"],
  //   loginResult: LoginModel.fromJson(json["loginResult"]),
  // );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  // Map<String, dynamic> toJson() => {
  //   "error": error,
  //   "message": message,
  //   "loginResult": loginResult.toJson(),
  // };

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
