import 'package:flutter/material.dart';
import 'package:{{appName.snakeCase()}}/core/sharedpreferences/user_shared_preferences.dart';
import 'package:{{appName.snakeCase()}}/presentation/screen/camera_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/screen/profile_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/screen/register_page.dart';
import 'package:{{appName.snakeCase()}}/presentation/screen/upload_story_page.dart';
import 'package:provider/provider.dart';

import '../../presentation/provider/story_provider.dart';
import '../../presentation/screen/auth_page.dart';
import '../../presentation/screen/detail_page.dart';
import '../../presentation/screen/feeds_page.dart';

class MyRouterDelegate extends RouterDelegate with
    ChangeNotifier, PopNavigatorRouterDelegateMixin{

  final GlobalKey<NavigatorState> _navKey;
  String? selectedStory;
  bool isLoggedIn = false;
  bool isRegisteredSelected = false;
  bool isUploadStorySelected = false;
  bool isProfileSelected = false;
  bool isCameraSelected = false;

  MyRouterDelegate() : _navKey = GlobalKey<NavigatorState>(){
    _init();
  }

  _init() async {
    isLoggedIn = UserSharedPreferences.isUserLoggedInPrefs();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navKey,
      pages : [
        if (!isLoggedIn)
          MaterialPage(
            child: AuthPage(
              isLoggedIn: (){
                isLoggedIn = true;
                notifyListeners();
              },
              isRegisterClicked: (){
                isRegisteredSelected = true;
                notifyListeners();
              },
            ),
          ),
        if (isLoggedIn)
          MaterialPage(
            child: FeedsPage(
                onSelectedStory: (storyId){
                  selectedStory = storyId;
                  final storyProvider = context.read<StoryProvider>();
                  final token = UserSharedPreferences.getUserPrefs().token;
                  storyProvider.getStoryDetail(token,storyId);
                  notifyListeners();
                },
                isUploadStorySelected: () {
                  isUploadStorySelected = true;
                  context.read<StoryProvider>().setPostStoryInitState();
                  notifyListeners();
                },
                isProfileSelected : (){
                  isProfileSelected = true;
                  notifyListeners();
                },
                userLoginEntity: UserSharedPreferences.getUserPrefs()
            ),
          ),
        if (isLoggedIn && isUploadStorySelected)
          MaterialPage(
              child: UploadStoryPage(
                isBackToFeedsPage: () {
                  isUploadStorySelected = false;
                  context.read<StoryProvider>().getListStory(
                      UserSharedPreferences.getUserPrefs().token
                  );
                  notifyListeners();
                },
                userLoginEntity: UserSharedPreferences.getUserPrefs(),
                goToCameraPage: () {
                  isCameraSelected = true;
                  notifyListeners();
                },
              )
          ),
        if (isLoggedIn && isProfileSelected)
          MaterialPage(
              child: ProfilePage(
                isBackToFeedsPage: (){
                  isProfileSelected = false;
                  notifyListeners();
                },
                loggingOut: (){
                  isLoggedIn = false;
                  isProfileSelected = false;
                  notifyListeners();
                },
                username: UserSharedPreferences.getUserPrefs().name,
              )
          ),
        if (isRegisteredSelected)
          MaterialPage(
            child: RegisterPage(
                isSuccessfulyRegistered: (){
                  isRegisteredSelected = false;
                  notifyListeners();
                }
            ),
          ),
        if (isLoggedIn && selectedStory != null)
          MaterialPage(
              child: DetailPage(
                storyId: selectedStory ?? "",
                token: UserSharedPreferences.getUserPrefs().token,
              )
          ),
        if (isLoggedIn && isCameraSelected)
          MaterialPage(
              child: CameraPage(
                cameras: context.read<StoryProvider>().listCameraDescription!,
                backToUploadPage: () {
                  isCameraSelected = false;
                  notifyListeners();
                },
              )
          )
      ],
      onPopPage: (route, result){
        final didPop = route.didPop(result);

        if (!didPop) {
          return false;
        }

        if (isCameraSelected){
          isCameraSelected = !isCameraSelected;
          notifyListeners();
          return true;
        }

        isRegisteredSelected = false;
        selectedStory = null;
        isUploadStorySelected = false;
        isProfileSelected = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

}