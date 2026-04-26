import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/constants/app_storage.dart';
import '../models/profile_model.dart';
import '../models/user.dart';
import '../routes/app_pages.dart';

class LoginCredential {
  late final GetStorage _getStorage;
  LoginCredential() {
    _getStorage = GetStorage();
  }

  void handleLoginCredential(Map<String, dynamic> loginResonse) {
    UserModel user = UserModel.fromMap(loginResonse['user']); //Retrieving User data from Login Response
    saveUserData(user);
    changeUserAuthState(true);
    saveAccessToken(loginResonse['accessToken']);
    saveRefreshToken(loginResonse['refreshToken']);
  }

//================================================================ User Data ================================================================//
  void saveUserData(UserModel model) {
    _getStorage.write(AppStorage.USER_DATA_KEY, model.toJson());
  }

  void saveGetUserInfoData(ProfileModel model) {
    _getStorage.write(AppStorage.USER_DATA_INFO_KEY, model.toJson());
  }

  ProfileModel getUserInfoData() {
    final data = _getStorage.read(AppStorage.USER_DATA_INFO_KEY);
    return ProfileModel.fromJson(data);
  }

  UserModel getUserData() {
    UserModel model = UserModel.fromJson(_getStorage.read(AppStorage.USER_DATA_KEY));
    return model;
  }

//================================================================ Access Token ================================================================//
  void saveAccessToken(String accessToken) {
    _getStorage.write(AppStorage.ACCESS_TOKEN, accessToken);
  }

  String? getAccessToken() {
    String? accessToken = _getStorage.read(AppStorage.ACCESS_TOKEN);
    return accessToken;
  }

  //================================================================ profile switched ================================================================//
  void saveProfileSwitch(bool value) {
    _getStorage.write(AppStorage.PROFILE_SWITCH_KEY, value);
  }

  bool getProfileSwitch() {
    bool? switchValue = _getStorage.read(AppStorage.PROFILE_SWITCH_KEY);
    return switchValue ?? false;
  }

//================================================================ Refresh Token ================================================================//

  void saveRefreshToken(String refreshToken) {
    _getStorage.write(AppStorage.REFRESH_TOKEN, refreshToken);
  }

  String? getRefreshToken() {
    String? refreshToken = _getStorage.read(AppStorage.REFRESH_TOKEN);
    return refreshToken;
  }
//================================================================ Auth State ================================================================//

  void changeUserAuthState(bool isLoggedIn) {
    _getStorage.write(AppStorage.AUTH_STATE_KEY, isLoggedIn);
  }

  bool isUserLoggedIn() {
    bool? isLoggedIn = _getStorage.read(AppStorage.AUTH_STATE_KEY);
    return isLoggedIn ?? false;
  }

  //================================================================ Language Settings ================================================================//
  // Save selected language
  void saveLanguage(String languageCode) {
    _getStorage.write(AppStorage.LANGUAGE_KEY, languageCode);
  }

  // Get saved language
  String? getSavedLanguage() {
    return _getStorage.read(AppStorage.LANGUAGE_KEY);
  }

  // Change language and update locale immediately
  void changeLanguage(String languageCode) {
    saveLanguage(languageCode);
    Get.updateLocale(Locale(languageCode));
  }

//================================================================ Clear Data ================================================================//

  void clearLoginCredential() {
    _getStorage.remove(AppStorage.USER_DATA_KEY);
    _getStorage.remove(AppStorage.AUTH_STATE_KEY);
    _getStorage.remove(AppStorage.REFRESH_TOKEN);
    _getStorage.remove(AppStorage.ACCESS_TOKEN);
    _getStorage.remove(AppStorage.PROFILE_SWITCH_KEY);
  }

  void clearLoginCredentialAndMoveToLogin() {
    _getStorage.remove(AppStorage.USER_DATA_KEY);
    _getStorage.remove(AppStorage.AUTH_STATE_KEY);
    _getStorage.remove(AppStorage.REFRESH_TOKEN);
    _getStorage.remove(AppStorage.ACCESS_TOKEN);
    _getStorage.remove(AppStorage.PROFILE_SWITCH_KEY);
    Get.offAllNamed(Routes.SPLASH);
  }

  //================================================================ Remember Me ================================================================//
  void saveRememberMe(bool value) {
    _getStorage.write(AppStorage.REMEMBER_ME_KEY, value);
  }

  bool getRememberMe() {
    return _getStorage.read(AppStorage.REMEMBER_ME_KEY) ?? true;
  }

// $┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
// $┃ ┃ ┃ ┃ ┃ ┃ ┃          CONFIG FOR DEEP LINK            ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
// $┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  static const String deepLinkKey = 'last_deep_link';
  Future<String?> getDeepLinkURL() async {
    String? deepLink = _getStorage.read(deepLinkKey);
    _getStorage.remove(deepLinkKey);
    return deepLink;
  }

// #┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
// #┃ ┃ ┃ ┃ ┃ ┃ ┃         CONFIG FOR DEEP LINK END         ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
// #┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛
}
