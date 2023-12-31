import 'package:{{appName.snakeCase()}}/core/utils/constants.dart';
import 'package:{{appName.snakeCase()}}/domain/entity/login_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
  static late SharedPreferences sharedPreferences;
  static Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future loginPrefs(LoginEntity loginEntity) async {
    await sharedPreferences.setString(tokenKey, loginEntity.token);
    await sharedPreferences.setString(nameKey, loginEntity.name);
    await sharedPreferences.setString(idKey, loginEntity.userId);
    await sharedPreferences.setBool(isLoginKey,true);
  }

  static Future logoutPrefs() async {
    await sharedPreferences.remove(tokenKey);
    await sharedPreferences.remove(nameKey);
    await sharedPreferences.remove(idKey);
    await sharedPreferences.setBool(isLoginKey,false);
  }

  static bool isUserLoggedInPrefs() {
    final isLoggedIn = sharedPreferences.getBool(isLoginKey) ?? false;
    return isLoggedIn;
  }

  static LoginEntity getUserPrefs(){
    final token = sharedPreferences.getString(tokenKey) ?? "";
    final name = sharedPreferences.getString(nameKey) ?? "";
    final id = sharedPreferences.getString(idKey) ?? "";
    return LoginEntity(userId: id, name: name, token: token);
  }
}