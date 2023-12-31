import 'dart:convert';

import 'package:{{appName.snakeCase()}}/domain/entity/login_entity.dart';

class LoginModel {
  String userId;
  String name;
  String token;

  LoginModel({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginModel.fromRawJson(String str) => LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    userId: json["userId"],
    name: json["name"],
    token: json["token"],
  );

  LoginEntity modelToEntity() => LoginEntity(
      userId: userId,
      name: name,
      token: token
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "token": token,
  };
}