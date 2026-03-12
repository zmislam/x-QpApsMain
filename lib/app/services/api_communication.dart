import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../config/constants/api_constant.dart';
import '../data/login_creadential.dart';
import '../models/api_response.dart';
import '../utils/file.dart';
import '../utils/image_utils.dart';
import '../utils/loader.dart';
import '../utils/snackbar.dart';
import 'REST_cacheing_service/cache_util.dart';

class ApiCommunication {
  late dio.Dio _dio;
  final String baseUrl = ApiConstant.BASE_URL;
  late Map<String, dynamic> header, responseData;
  late Connectivity connectivity;
  late LoginCredential _loginCredential;
  late String? token;

  ApiCommunication({int? connectTimeout, int? receiveTimeout}) {
    _dio = Dio();
    // ..interceptors.add(PrettyDioLogger(
    //   requestHeader: true,
    //   requestBody: true,
    //   responseBody: true,
    // ));
    _dio.options.connectTimeout =
        Duration(milliseconds: connectTimeout ?? 60000); //1000 = 1s
    _dio.options.receiveTimeout =
        Duration(milliseconds: receiveTimeout ?? 60000);

    connectivity = Connectivity();
    _loginCredential = LoginCredential();
    token = _loginCredential.getAccessToken();
    header = {
      'Accept': '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> _getHeaders() {
      final token = _loginCredential.getAccessToken();
      return {
        'Accept': '*/*',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
  }

  Future<bool> isConnectedToInternet() async {
    // debugPrint('Checking connectivity for baseUrl: $baseUrl');
    // For local development (baseUrl points to localhost or local IP), 
    // we bypass all connectivity checks to allow local traffic.
    if (baseUrl.contains('localhost') || baseUrl.contains('192.168') || baseUrl.contains('127.0.0.1')) {
      return true;
    }

    final connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi)) {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<ApiResponse> doPostRequest({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    List<XFile>? mediaXFiles,
    List<File>? mediaFiles,
    String? fileKey,
    Map<String, File>? fileMap, // ✅ add this line
    String? errorMessage,
    bool enableLoading = false,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    print(requestUrl);
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      if (enableLoading) showLoader();

      final Object? requestObject;
      if (isFormData) {
        FormData requestFormData = FormData.fromMap(requestData ?? <String, dynamic>{});

        // ✅ Handle single fileKey (existing behavior)
        if (mediaXFiles != null && mediaXFiles.isNotEmpty) {
          List multiparts = await getMultipartFilesFromXfiles(mediaXFiles);
          for (dio.MultipartFile singleMultipart in multiparts) {
            requestFormData.files.add(MapEntry(fileKey ?? 'files', singleMultipart));
          }
        }
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          for (File mediaFile in mediaFiles) {
            requestFormData.files.add(MapEntry(
              fileKey ?? 'files',
              dio.MultipartFile.fromFileSync(
                mediaFile.path,
                contentType: getMediaTypeFromFile(mediaFile),
                filename: getFileNameFromFile(mediaFile),
              ),
            ));
          }
        }

        // ✅ Handle multiple file keys (new behavior)
        if (fileMap != null && fileMap.isNotEmpty) {
          fileMap.forEach((key, file) {
            requestFormData.files.add(MapEntry(
              key,
              dio.MultipartFile.fromFileSync(
                file.path,
                contentType: getMediaTypeFromFile(file),
                filename: getFileNameFromFile(file),
              ),
            ));
          });
        }

        requestObject = requestFormData;
      } else {
        requestObject = requestData;
      }

      try {
        response = await _dio.post(
          requestUrl,
          data: requestObject,
          options: dio.Options(headers: header),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap = error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (_) {
          responseErrorMessage = 'Api Error';
        }
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE ? responseData[responseDataKey] : responseData,
        );
      } else {
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doPostRequestNew({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    dynamic processedFileNames, // ✅ Accept both String or List<String>
    String? fileKey,
    String? errorMessage,
    bool enableLoading = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      if (enableLoading) showLoader();

      Map<String, dynamic> jsonDataMap = requestData ?? <String, dynamic>{};

      // ✅ Handle processedFileNames (String or List<String>)
      if (processedFileNames != null) {
        if (processedFileNames is List<String> && processedFileNames.isNotEmpty) {
          jsonDataMap[fileKey ?? 'files'] = processedFileNames;
        } else if (processedFileNames is String && processedFileNames.isNotEmpty) {
          jsonDataMap[fileKey ?? 'files'] = processedFileNames;
        }
      }

      try {
        response = await _dio.post(
          requestUrl,
          data: jsonDataMap,
          options: dio.Options(
            headers: header,
            contentType: 'application/json',
          ),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap = error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }


  Future<ApiResponse> newDoPostRequest({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    String? fileName,
    List<String>? fileNames,
    String? fileKey,
    String? errorMessage,
    bool enableLoading = false,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      if (enableLoading) showLoader();

      Map<String, dynamic> dataMap = requestData ?? <String, dynamic>{};

      // Add single filename if provided separately
      if (fileName != null && fileName.isNotEmpty) {
        dataMap[fileKey ?? 'profile_pic'] = fileName;
      }

      // Add multiple filenames if provided
      if (fileNames != null && fileNames.isNotEmpty) {
        dataMap[fileKey ?? 'files'] = fileNames;
      }

      debugPrint('📤 Request URL: $requestUrl');
      debugPrint('📤 Request Data: $dataMap');

      try {
        response = await _dio.post(
          requestUrl,
          data: dataMap,
          options: dio.Options(
            headers: {
              ...header,
              'Content-Type': isFormData
                  ? 'multipart/form-data'
                  : 'application/x-www-form-urlencoded',
            },
          ),
        );

        debugPrint('✅ Response: ${response.statusCode}');
        if (enableLoading) dismissLoader();
      } on dio.DioException catch (error) {
        if (enableLoading) dismissLoader();
        debugPrint('❌ DioException: ${error.response?.data}');

        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          final messageMap = error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'] ?? 'Unknown API error';
        } catch (_) {
          responseErrorMessage = 'Api Error';
        }
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        debugPrint('❌ SocketException: ${error.message}');
        return ApiResponse(isSuccessful: false, message: error.message);
      } catch (error) {
        if (enableLoading) dismissLoader();
        debugPrint('❌ Error: $error');
        return ApiResponse(isSuccessful: false, message: error.toString());
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
          message: response.statusMessage,
        );
      }
    } else {
      errorMessage = 'You are not connected to the internet';
      showWarningSnackkbar(message: errorMessage);
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }


  Future<ApiResponse> doGetRequest({
    required String apiEndPoint,
    bool enableLoading = false,
    String? errorMessage,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
    Map<String, dynamic>? queryParameters, // Add queryParameters argument

    /// Only Applicable for data caching with GET request
    /// Default value will be considered [False] unless the cache is enabled for any given API
    /// it wont activate the cache
    bool? enableCache,

    /// For APIs with cache enabled, set the time to live for the stored data.
    /// IF the value is not given default value [120 Seconds] will be used
    int? timeToLiveInSeconds,

    /// Invalidate the previous stored data and recall the API if cache is enabled
    /// the default value is [False] unless specifically mentioned [True] in the api call
    bool? forceRecallAPI,
  }) async {
    if (await isConnectedToInternet()) {
      if (enableLoading) showLoader();
      dio.Response? response;

      late String responseErrorMessage;
      String requestUrl = '$baseUrl$apiEndPoint';
      try {
        // Make the GET request and pass queryParameters

        final CacheUtil cacheUtil = CacheUtil.instance;

        // Invalidate the cache if force recall is true
        if (forceRecallAPI ?? false) {
          cacheUtil.forceInvalidateCache(
              apiUrl: requestUrl,
              header: header,
              queryParameters: queryParameters);
        }

        // CUSTOM CACHE IMPL ____________________________
        if (enableCache ?? false) {
          // Don't need to get data if force recall is true..
          if (!(forceRecallAPI ?? false)) {
            response = cacheUtil.getRESTDataFromCache(
                apiUrl: requestUrl,
                queryParameters: queryParameters,
                header: header);
          }

          if (response == null) {
            response = await _dio.get(
              requestUrl,
              queryParameters:
                  queryParameters, // Pass query parameters to Dio's GET method
              options: dio.Options(headers: header),
            );

            cacheUtil.storeRESTDataInCache(
                apiUrl: requestUrl,
                queryParameters: queryParameters,
                header: header,
                response: response,
                timeToLive: timeToLiveInSeconds);
          }
        }
        // GENERAL IMPL OF API CALL -------------------------------------
        else {
          response = await _dio.get(
            requestUrl,
            queryParameters:
                queryParameters, // Pass query parameters to Dio's GET method
            options: dio.Options(headers: header),
          );
        }

        // Dismissing Loader
        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        // Dismissing Loader
        if (enableLoading) dismissLoader();
        // Retrieving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        //! Returning DioException Error Response
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // Showing Error Message
        //! Returning SocketException Error Response
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        // Dismissing Loader
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        //! Returning catch Error Response of api calling
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }
      if (response.statusCode == 200) {
        var responseData = response.data; // Getting success Response data
        // Showing Success message
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        //! Returning Other Status Code Error Response
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doPostFormRequest({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    List<XFile>? mediaXFiles,
    List<String>? fileKeys,
    List<File>? mediaFiles,
    String? fileKey,
    String? errorMessage,
    bool enableLoading = false,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      // Internet Connection is available
      if (enableLoading) showLoader();
      final Object? requestObject;
      if (isFormData) {
        // If request data is Form data
        FormData requestFormData =
            FormData.fromMap(requestData ?? <String, dynamic>{});
        if (mediaXFiles != null && mediaXFiles.isNotEmpty) {
          // Having XFile to attatch
          List multiparts = await getMultipartFilesFromXfiles(mediaXFiles);

          for (int i = 0; i < multiparts.length; i++) {
            requestFormData.files
                .add(MapEntry(fileKeys?[i] ?? 'files', multiparts[i]));
          }
        }
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          // Having File to attatch
          //   for (int i = 0; i < mediaFiles.length; i++) {
          //     requestFormData.files.add(MapEntry(
          //         fileKeys?[i] ?? 'files',
          //         dio.MultipartFile.fromFileSync(mediaFiles[i].path,
          //             contentType: getMediaTypeFromFile(mediaFiles[i]),
          //             filename: getFileNameFromFile(mediaFiles[i]))));
          //   }
          // }

          // Having File to attach
          for (int i = 0; i < mediaFiles.length; i++) {
            // If fileKeys is null or has fewer entries, fallback to 'files'
            final fileKey = (fileKeys != null && fileKeys.length > i)
                ? fileKeys[i]
                : 'files';

            requestFormData.files.add(
              MapEntry(
                fileKey,
                dio.MultipartFile.fromFileSync(
                  mediaFiles[i].path,
                  contentType: getMediaTypeFromFile(mediaFiles[i]),
                  filename: getFileNameFromFile(mediaFiles[i]),
                ),
              ),
            );
          }
        }

        requestObject = requestFormData;
      } else {
        // If request data is Raw data

        requestObject = requestData;
      }
      try {
        response = await _dio.post(
          requestUrl,
          data: requestObject,
          options: dio.Options(headers: header),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();
        // Retriving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doPatchRequest({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    List<XFile>? mediaXFiles,
    List<File>? mediaFiles,
    String? fileKey,
    String? errorMessage,
    bool enableLoading = false,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      // Internet Connection is available
      if (enableLoading) showLoader();
      final Object? requestObject;
      if (isFormData) {
        // If request data is Form data
        FormData requestFormData =
            FormData.fromMap(requestData ?? <String, dynamic>{});
        if (mediaXFiles != null && mediaXFiles.isNotEmpty) {
          // Having XFile to attatch
          List multiparts = await getMultipartFilesFromXfiles(mediaXFiles);
          for (dio.MultipartFile singleMultipart in multiparts) {
            requestFormData.files
                .add(MapEntry(fileKey ?? 'files', singleMultipart));
          }
        }
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          // Having File to attatch
          for (File mediaFile in mediaFiles) {
            requestFormData.files.add(MapEntry(
                fileKey ?? 'files',
                dio.MultipartFile.fromFileSync(mediaFile.path,
                    contentType: getMediaTypeFromFile(mediaFile),
                    filename: getFileNameFromFile(mediaFile))));
          }
        }

        requestObject = requestFormData;
      } else {
        // If request data is Raw data

        requestObject = requestData;
      }
      try {
        response = await _dio.patch(
          requestUrl,
          data: requestObject,
          options: dio.Options(headers: header),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();

        // Retriving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'] ??
              messageMap['errors']?.toString() ?? // Handle both string or map
              'Api Error';
        } catch (e) {
          responseErrorMessage = 'Api Error';
        }
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doDeleteRequest({
    required String apiEndPoint,
    Map<String, dynamic>? requestData,
    List<XFile>? mediaXFiles,
    List<File>? mediaFiles,
    String? fileKey,
    String? errorMessage,
    bool enableLoading = false,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    String requestUrl = '$baseUrl$apiEndPoint';
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      // Internet Connection is available
      if (enableLoading) showLoader();
      final Object? requestObject;
      if (isFormData) {
        // If request data is Form data
        FormData requestFormData =
            FormData.fromMap(requestData ?? <String, dynamic>{});
        if (mediaXFiles != null && mediaXFiles.isNotEmpty) {
          // Having XFile to attach
          List multiparts = await getMultipartFilesFromXfiles(mediaXFiles);
          for (dio.MultipartFile singleMultipart in multiparts) {
            requestFormData.files
                .add(MapEntry(fileKey ?? 'files', singleMultipart));
          }
        }
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          // Having File to attach
          for (File mediaFile in mediaFiles) {
            requestFormData.files.add(MapEntry(
                fileKey ?? 'files',
                dio.MultipartFile.fromFileSync(mediaFile.path,
                    contentType: getMediaTypeFromFile(mediaFile),
                    filename: getFileNameFromFile(mediaFile))));
          }
        }
        requestObject = requestFormData;
      } else {
        // If request data is Raw data
        requestObject = requestData;
      }
      try {
        response = await _dio.delete(
          requestUrl,
          data: requestObject,
          options: dio.Options(headers: header),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();
        // Retrieving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doThirdParyGetRequest({
    required String requestUrl,
    bool enableLoading = false,
    String? errorMessage,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    if (await isConnectedToInternet()) {
      if (enableLoading) showLoader();
      dio.Response? response;

      late String responseErrorMessage;
      try {
        response = await _dio.get(
          requestUrl,
          options: dio.Options(headers: header),
        );
        // Dismissing Loader
        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        // Dismissing Loader
        if (enableLoading) dismissLoader();
        // Retriving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        // Showing Error Message
        // showErrorSnackkbar(message: responseErrorMessage);
        //! Returning DioException Error Response
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // Showing Error Message
        // showErrorSnackkbar(message: responseErrorMessage);
        //! Returning SocketException Error Response
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        // Dismissing Loader
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        //! Returning catch  Error Response of api calling
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }
      if (response.statusCode == 200) {
        responseData = response.data; // Getting success Response data
        // Showing Success message
        return ApiResponse(
          isSuccessful: true,
          statusCode: responseData[ApiConstant.STATUS_CODE_KEY],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        //! Returning Other Status Code Error Response
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  Future<ApiResponse> doThirdPartyPostRequest({
    required String requestUrl,
    Map<String, dynamic>? requestData,
    bool enableLoading = false,
    String? errorMessage,
    Map<String, dynamic>? headerMap,
    List<XFile>? mediaXFiles,
    List<File>? mediaFiles,
    String? fileKey,
    bool isFormData = false,
    String responseDataKey = ApiConstant.DATA_RESPONSE,
  }) async {
    dio.Response? response;
    late String responseErrorMessage;

    if (await isConnectedToInternet()) {
      // Internet Connection is available
      if (enableLoading) showLoader();
      final Object? requestObject;
      if (isFormData) {
        // If request data is Form data
        FormData requestFormData =
            FormData.fromMap(requestData ?? <String, dynamic>{});
        if (mediaXFiles != null && mediaXFiles.isNotEmpty) {
          // Having XFile to attatch
          List multiparts = await getMultipartFilesFromXfiles(mediaXFiles);
          for (dio.MultipartFile singleMultipart in multiparts) {
            requestFormData.files
                .add(MapEntry(fileKey ?? 'files', singleMultipart));
          }
        }
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          // Having File to attatch
          for (File mediaFile in mediaFiles) {
            requestFormData.files.add(MapEntry(
                fileKey ?? 'files',
                dio.MultipartFile.fromFileSync(mediaFile.path,
                    contentType: getMediaTypeFromFile(mediaFile),
                    filename: getFileNameFromFile(mediaFile))));
          }
        }

        requestObject = requestFormData;
      } else {
        // If request data is Raw data

        requestObject = requestData;
      }
      try {
        response = await _dio.post(
          requestUrl,
          data: requestObject,
          options: dio.Options(headers: headerMap),
        );

        if (enableLoading) dismissLoader();
      } on DioException catch (error) {
        if (enableLoading) dismissLoader();
        // Retriving Response Error
        if (error.response?.statusCode == 401) {
          _loginCredential.clearLoginCredentialAndMoveToLogin();
        }
        try {
          Map<String, dynamic> messageMap =
              error.response?.data as Map<String, dynamic>;
          responseErrorMessage = messageMap['message'];
        } catch (error) {
          responseErrorMessage = 'Api Error';
        }
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } on SocketException catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.message;
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(isSuccessful: false, message: responseErrorMessage);
      } catch (error) {
        if (enableLoading) dismissLoader();
        responseErrorMessage = error.toString();
        // showErrorSnackkbar(message: responseErrorMessage);
        return ApiResponse(
          isSuccessful: false,
          message: responseErrorMessage,
        );
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        return ApiResponse(
          isSuccessful: true,
          statusCode: 200,
          // statusCode: int.parse(responseData[ApiConstant.STATUS_CODE_KEY]),
          message: responseData['message'],
          data: responseDataKey != ApiConstant.FULL_RESPONSE
              ? responseData[responseDataKey]
              : responseData,
        );
      } else {
        // showErrorSnackkbar(message: '${response.statusCode}');
        return ApiResponse(
          isSuccessful: false,
          statusCode: response.statusCode,
        );
      }
    } else {
      errorMessage = 'You are not connected with mobile/wifi network';
      showWarningSnackkbar(message: errorMessage);
      //! Returning Network Not found Error Response
      return ApiResponse(
        isSuccessful: false,
        statusCode: 503,
        message: errorMessage,
      );
    }
  }

  void endConnection() => _dio.close(force: true);
}
