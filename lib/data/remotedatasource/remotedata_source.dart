import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intermediate_flutter_story_app/core/exceptionfailure/exception.dart';
import 'package:intermediate_flutter_story_app/data/model/login_model.dart';
import 'package:intermediate_flutter_story_app/data/model/story_detail_model.dart';
import 'package:intermediate_flutter_story_app/data/model/story_model.dart';
import 'package:intermediate_flutter_story_app/data/remotedatasource/response/login_response.dart';
import 'package:intermediate_flutter_story_app/data/remotedatasource/response/server_response.dart';
import 'package:intermediate_flutter_story_app/data/remotedatasource/response/story_detail_response.dart';
import 'package:intermediate_flutter_story_app/data/remotedatasource/response/story_list_response.dart';

abstract class RemoteDataSource{
  Future<List<StoryModel>> getStoryList(String token, String page, String sizeItems);
  Future<StoryDetailModel> getStoryDetail(String id, String token);
  Future<LoginModel> login(String email, String pass);
  Future<String> register(String name, String email, String pass);
  Future<String> postStory(
      String token,
      String desc,
      List<int> bytes,
      String fileName,
      double? lat,
      double? lon
      );
}

class RemoteDataSourceImpl implements RemoteDataSource{

  final Dio dio;
  static const baseUrl = "https://story-api.dicoding.dev/v1";
  static const endpointRegister = "/register";
  static const endpointLogin = "/login";
  static const endpointAccountAddStory = "/stories";
  // static const endpointGuestAddStory = "/stories/guest";
  static const endpointGetStories = "/stories?";
  static const endpointGetDetail= "/stories/";


  const RemoteDataSourceImpl({required this.dio});


  @override
  Future<String> register(String name, String email, String pass) async {
    try {
      final registerResponse = await dio.post(baseUrl + endpointRegister,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
          data: jsonEncode({"name": name, "email": email, "password": pass})
      );
      if (registerResponse.statusCode == 201) {
        return ServerResponse.fromJson(registerResponse.data).message;
      } else {
        throw const ServerException(
            msg: "Server Problem Occured"
        );
      }
    } on DioException catch (e){
      if (e.response != null) {
        throw ServerException(
            msg: e.response!.data["message"]
        );
      } else {
        throw const ConnectionException(
            msg: "Internet Connection Problem!"
        );
      }
    }
  }

  @override
  Future<LoginModel> login(String email, String pass) async {
    try {
      final loginResponse = await dio.post(
        baseUrl+endpointLogin,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader:"application/json"
          }
        ),
        data: jsonEncode({"email":email, "password":pass})
      );

      if (loginResponse.statusCode == 200) {
        return LoginResponse.fromJson(loginResponse.data).loginResult;
      } else {
        throw const ServerException(
            msg: "Server Problem Occured"
        );
      }
    } on DioException catch (e){
      if (e.response != null) {
        throw ServerException(
            msg: e.response!.data["message"]
        );
      } else {
        throw const ConnectionException(
            msg: "Internet Connection Problem!"
        );
      }
    }
  }

  @override
  Future<List<StoryModel>> getStoryList(
      String token, String page, String sizeItems
      ) async {
    try {
      final storyListResponse = await dio.get(
          "$baseUrl${endpointGetStories}size=$sizeItems&page=$page",
          options: Options(
              headers: {
                "Authorization" : "Bearer $token"
              }
          )
      );

      if (storyListResponse.statusCode == 200){
        return StoryListResponse.fromJson(storyListResponse.data).listStory;
      } else {
        throw const ServerException(
            msg: "Incorrect/expired bearer token"
        );
      }
    } on DioException catch (e){
      if (e.response != null) {
        throw ServerException(
            msg: e.response!.data["message"]
        );
      } else {
        throw const ConnectionException(
            msg: "Internet Connection Problem!"
        );
      }
    }
  }

  @override
  Future<StoryDetailModel> getStoryDetail(String id, String token) async {
    try{
      final storyDetailResponse = await dio.get(
        baseUrl+endpointGetDetail+id,
        options: Options(
          headers: {
            "Authorization": "Bearer $token"
          }
        )
      );
      if (storyDetailResponse.statusCode == 200){
        return StoryDetailResponse.fromJson(storyDetailResponse.data).story;
      } else {
        throw const ServerException(
            msg: "Incorrect/expired bearer token"
        );
      }
    } on DioException catch (e){
      if (e.response != null) {
        throw ServerException(
            msg: e.response!.data["message"]
        );
      } else {
        throw const ConnectionException(
            msg: "Internet Connection Problem!"
        );
      }
    }
  }

  @override
  Future<String> postStory(
      String token,
      String desc,
      List<int> bytes,
      String fileName,
      double? lat,
      double? lon
      ) async {
    try {
      var formData = FormData.fromMap({
        'photo': MultipartFile.fromBytes(bytes, filename: fileName),
        'description' : desc,
        'lat': lat,
        'lon': lon
      });

      final postStoryResponse = await dio.post(
          baseUrl+endpointAccountAddStory,
          options: Options(
              headers: {
                "Authorization" : "Bearer $token",
                HttpHeaders.contentTypeHeader : "multipart/form-data"
              }
          ),
          data: formData
      );
      if (postStoryResponse.statusCode == 201){
        return ServerResponse.fromJson(postStoryResponse.data).message;
      } else {
        throw const ServerException(
            msg: "Incorrect/expired bearer token"
        );
      }
    } on DioException catch (e){
      if (e.response != null) {
        throw ServerException(
            msg: e.response!.data["message"]
        );
      } else {
        throw const ConnectionException(
            msg: "Internet Connection Problem!"
        );
      }
    }
  }
}