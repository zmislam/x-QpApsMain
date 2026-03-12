import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/login_creadential.dart';
import 'cached_data_model.dart';

class CacheUtil {
  late final GetStorage _getStorage;
  final LoginCredential _loginCredential = LoginCredential();

  CacheUtil._internal() {
    _getStorage = GetStorage('rest_cache');
  }

  static final CacheUtil _instance = CacheUtil._internal();

  // Getter for the instance
  static CacheUtil get instance => _instance;

  // TTL In seconds
  static const int _TTL_VALUE = 120;

  // Generate const key
  String _getConstantKey({
    required String apiUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) {
    // Convert query parameters and header to sorted JSON strings to ensure consistency
    String queryParamsString = jsonEncode(queryParameters ?? {});
    String headerString = jsonEncode(header ?? {});

    // Generate a unique key string
    String rawKey = '${apiUrl}_${queryParamsString}_$headerString|${_loginCredential.getAccessToken()}';

    // Hash the raw key using SHA-256
    Digest hash = sha256.convert(utf8.encode(rawKey));


    // Convert to hex and return 256 bit key
    return hash.toString();
  }

  // Generate Storage TTL
  int _getStorageTTL({int? timeToLive}) {
    return DateTime.now().add(Duration(seconds: timeToLive ?? _TTL_VALUE)).millisecondsSinceEpoch;
  }

  // store the response with key

  void _storeResponseDataWithKey({required String key, required Response<dynamic> response, int? timeToLive}) {
    CachedDataModel cachedDataModel = CachedDataModel(
      responseBody: response.data,
      statusCode: response.statusCode ?? 0,
      requestOptions: response.requestOptions,
      ttl: _getStorageTTL(timeToLive: timeToLive),
    );

    _getStorage.write(key, cachedDataModel.toJson());
  }

  void _deleteData({required String key}) {
    _getStorage.remove(key);
  }

  bool _doseKeyExist({required String key}) {
    return _getStorage.hasData(key);
  }

  // check validity of data lifespan

  bool _checkDataValidity({required String key}) {
    CachedDataModel cachedDataModel = CachedDataModel.fromJson(_getStorage.read(key));
    if (DateTime.fromMillisecondsSinceEpoch(cachedDataModel.ttl).isAfter(DateTime.now())) {
      return true;
    }

    // Remove invalid data..
    _deleteData(key: key);
    return false;
  }

  // get data from storage ----------------------------- PUBLIC FUNCTIONS --------------------

  Response<dynamic>? getRESTDataFromCache({
    required String apiUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) {
    try {
      final String key = _getConstantKey(apiUrl: apiUrl, queryParameters: queryParameters, header: header);

      if (!_doseKeyExist(key: key)) return null;

      final bool isDatValid = _checkDataValidity(key: key);
      if (!isDatValid) return null;

      CachedDataModel cachedDataModel = CachedDataModel.fromJson(_getStorage.read(key));

      Response response = Response(
        data: cachedDataModel.responseBody,
        statusCode: cachedDataModel.statusCode,
        requestOptions: cachedDataModel.requestOptions,
      );
      debugPrint('COLLECTING DATA FROM CACHE :::::::: $apiUrl');
      return response;
    } catch (error) {
      debugPrint('ERROR: $error');
      return null;
    }
  }

  void storeRESTDataInCache({
    required String apiUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    required Response<dynamic> response,
    int? timeToLive,
  }) {
    final String key = _getConstantKey(apiUrl: apiUrl, queryParameters: queryParameters, header: header);

    // This segment is extra check-----------
    if (_doseKeyExist(key: key)) {
      if (_checkDataValidity(key: key)) return;
    }

    debugPrint('STORING DATA IN CACHE :::::::: $apiUrl');
    _storeResponseDataWithKey(key: key, response: response, timeToLive: timeToLive);
  }

  void forceInvalidateCache({
    required String apiUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) {
    try {
      final String key = _getConstantKey(apiUrl: apiUrl, queryParameters: queryParameters, header: header);

      if (!_doseKeyExist(key: key)) return;

      // Remove data if exist..
      _deleteData(key: key);

      debugPrint('FORCE CLEANED DATA FROM CACHE :::::::: $apiUrl');
      return;
    } catch (error) {
      debugPrint('ERROR: $error');
      return;
    }
  }

  void clearAllCache() {
    debugPrint('STORAGE STATE BEFORE------------------------------------');
    print(_getStorage.getKeys());
    _getStorage.erase();
    debugPrint('STORAGE STATE END *****************************************');
    print(_getStorage.getKeys());
  }
}
