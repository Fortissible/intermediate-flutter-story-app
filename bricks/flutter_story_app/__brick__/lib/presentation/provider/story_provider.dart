import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:{{appName.snakeCase()}}/domain/entity/story_detail_entity.dart';
import 'package:{{appName.snakeCase()}}/domain/repository/repository.dart';
import '../../domain/entity/story_entity.dart';

enum ListStoryState { init, loading, noData, hasData, error }
enum StoryDetailState { init, loading, noData, hasData, error }
enum UploadStoryState { init, loading, hasData, error }

class StoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  List<CameraDescription>? _listCameraDescription;
  List<StoryEntity> _listStoryEntity = [];
  StoryDetailEntity? _storyDetailEntity;
  String? _postResponse;
  String? _errorMsg;
  UploadStoryState _uploadStoryState = UploadStoryState.init;
  StoryDetailState _storyDetailState = StoryDetailState.init;
  ListStoryState _listStoryState = ListStoryState.init;

  List<StoryEntity>? get listStoryEntity => _listStoryEntity;
  StoryDetailEntity? get storyDetailEntity => _storyDetailEntity;
  String? get postResponse => _postResponse;
  String? get errorMsg => _errorMsg;
  UploadStoryState get uploadStoryState => _uploadStoryState;
  StoryDetailState get storyDetailState => _storyDetailState;
  ListStoryState get listStoryState => _listStoryState;
  List<CameraDescription>? get listCameraDescription => _listCameraDescription;

  int? page = 1;
  int sizeItems = 10;

  final Repository repository;

  StoryProvider({required this.repository});

  void setListCameraDescription(List<CameraDescription> cameras){
    _listCameraDescription = cameras;
  }

  void setPostStoryInitState(){
    _uploadStoryState = UploadStoryState.init;
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<void> refreshListStory(String token) async {
    _listStoryEntity = [];
    page = 1;
    _errorMsg = null;
    await getListStory(token);
  }

  Future getListStory(String token) async {
    if (page == 1){
      _listStoryState = ListStoryState.loading;
    }

    _errorMsg = null;

    final storyListEntityFold = await repository.getStoryList(
        token, page.toString(), sizeItems.toString()
    );

    storyListEntityFold.fold(
            (l) {

          _errorMsg = l.msg;
          _listStoryState = ListStoryState.error;

        },
            (r) {

          if (r.isEmpty) {

            _listStoryState = ListStoryState.noData;
            page = null;

          } else {

            if (r.length < sizeItems) {
              page = null;
            }

            _listStoryState = ListStoryState.hasData;
            _listStoryEntity.addAll(r);
            page = page! + 1;

          }
        }
    );

    notifyListeners();
  }

  Future getStoryDetail(String token, String id) async {

    _errorMsg = null;
    _storyDetailEntity = null;

    final storyDetailEntityFold = await repository.getStoryDetail(token, id);
    storyDetailEntityFold.fold(
            (l) {
          _errorMsg = l.msg;
          _storyDetailState = StoryDetailState.error;
        },
            (r) {
          if (r.photoUrl.isEmpty) {
            _storyDetailState = StoryDetailState.noData;
            _storyDetailEntity = r;
          } else {
            _storyDetailState = StoryDetailState.hasData;
            _storyDetailEntity = r;
          }
        }
    );
    notifyListeners();
  }

  Future postStory(
      String token, String desc, List<int> bytes, String filename, LatLng? latLng
      ) async {
    _uploadStoryState = UploadStoryState.loading;
    notifyListeners();

    _errorMsg = null;
    _postResponse = null;

    final bytes = await imageFile!.readAsBytes();
    final bytesList = bytes.toList();
    final responseFold = await repository.postStory(
        token, desc, bytesList, filename,
        latLng?.latitude,
        latLng?.longitude
    );
    responseFold.fold(
            (l) {
          _errorMsg = l.msg;
          _uploadStoryState = UploadStoryState.error;
        },
            (r) {
          _postResponse = r;
          _uploadStoryState = UploadStoryState.hasData;
        }
    );
    notifyListeners();
  }

  Future<List<int>> compressImage(Uint8List bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  Future<bool> askLocationPermission() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}