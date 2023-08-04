import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intermediate_flutter_story_app/domain/entity/story_detail_entity.dart';
import 'package:intermediate_flutter_story_app/domain/repository/repository.dart';

import '../../domain/entity/story_entity.dart';

enum ResultState { init, loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  List<StoryEntity>? _listStoryEntity;
  StoryDetailEntity? _storyDetailEntity;
  String? _postResponse;
  String? _errorMsg;
  ResultState _state = ResultState.init;

  List<StoryEntity>? get listStoryEntity => _listStoryEntity;
  StoryDetailEntity? get storyDetailEntity => _storyDetailEntity;
  String? get postResponse => _postResponse;
  String? get errorMsg => _errorMsg;
  ResultState get state => _state;

  final Repository repository;

  StoryProvider({required this.repository});

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void getListStory(String token) async {
    _state = ResultState.loading;
    notifyListeners();

    _errorMsg = null;
    _listStoryEntity = null;

    final storyListEntityFold = await repository.getStoryList(token);
    storyListEntityFold.fold(
            (l) {
              _errorMsg = l.msg;
              _state = ResultState.error;
            },
            (r) {
              if (r.isEmpty) {
                _state = ResultState.noData;
                _listStoryEntity = r;
              } else {
                _state = ResultState.hasData;
                _listStoryEntity = r;
              }
            }
    );

    notifyListeners();
  }

  void getStoryDetail(String token, String id) async {
    final storyListEntityFold = await repository.getStoryDetail(token, id);
    storyListEntityFold.fold(
            (l) => _errorMsg = l.msg,
            (r) => _storyDetailEntity = r
    );
    notifyListeners();
  }

  void postStory(String token, String? desc) async {
    final bytes = await imageFile?.readAsBytes();
    final bytesList = bytes?.toList();
    final responseFold = await repository.postStory(token, desc??"", bytesList!, imageFile?.name??"");
    responseFold.fold(
            (l) => _errorMsg = l.msg,
            (r) => _postResponse = r
    );
    notifyListeners();
  }
}