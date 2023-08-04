import 'package:flutter/material.dart';
import 'package:intermediate_flutter_story_app/core/sharedpreferences/user_shared_preferences.dart';
import 'package:intermediate_flutter_story_app/presentation/screen/profile_page.dart';
import 'package:intermediate_flutter_story_app/presentation/screen/register_page.dart';
import 'package:intermediate_flutter_story_app/presentation/screen/upload_story_page.dart';

import '../../domain/entity/login_entity.dart';
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
  LoginEntity? userLoginEntity;

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
              isLoggedIn: (value){
                isLoggedIn = value;
                notifyListeners();
              },
              isRegisterClicked: (value){
                isRegisteredSelected = value;
                notifyListeners();
              },
            ),
          ),
        if (isLoggedIn)
          MaterialPage(
            child: FeedsPage(
              onSelectedStory: (value){
                selectedStory = value;
                notifyListeners();
              },
              isUploadStorySelected: (value) {
                isUploadStorySelected = value;
                notifyListeners();
              },
              isProfileSelected : (value){
                isProfileSelected = value;
                notifyListeners();
              },
              userLoginEntity: UserSharedPreferences.getUserPrefs()
            ),
          ),
        if (isLoggedIn && isUploadStorySelected)
          MaterialPage(
            child: UploadStoryPage(
              isBackToFeedsPage: (value) {
                isUploadStorySelected = !value;
                notifyListeners();
              },
              userLoginEntity: UserSharedPreferences.getUserPrefs(),
            )
          ),
        if (isLoggedIn && isProfileSelected)
          MaterialPage(
            child: ProfilePage(
              isBackToFeedsPage: (value){
                isProfileSelected = !value;
                notifyListeners();
              },
              loggingOut: (value){
                isLoggedIn = !value;
                notifyListeners();
              },
              username: UserSharedPreferences.getUserPrefs().name,
            )
          ),
        if (isRegisteredSelected)
          MaterialPage(
            child: RegisterPage(
                isSuccessfulyRegistered: (value){
                  isRegisteredSelected = !value;
                  notifyListeners();
                }
            ),
          ),
        if (selectedStory != null)
          MaterialPage(
              child: DetailPage(
                storyId: selectedStory ?? "",
                token: UserSharedPreferences.getUserPrefs().token,
              )
          )
      ],
      onPopPage: (route, result){
        final didPop = route.didPop(result);

        if (!didPop) {
          return false;
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
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

}