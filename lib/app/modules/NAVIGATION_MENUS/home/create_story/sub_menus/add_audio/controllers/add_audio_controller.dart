import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../services/api_communication.dart';

import '../../../../../../../services/audio_player_service.dart';
import '../models/audio_model.dart';

class AddAudioController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final AudioPlayerService audioPlayerService;
  late final TextEditingController audioSearchTextController;
  final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  Rx<List<AudioModel>> audioList = Rx([]);
  late final ScrollController audioListScrollController;

  Rx<List<AudioModel>> recentAudioList = Rx([]);
  late final ScrollController recentAudioListScrollController;

  Rx<List<AudioModel>> favoriteAudioList = Rx([]);
  late final ScrollController favoriteAudioListScrollController;

  late int currentlySelectedTab;

  void onSearchTextChange(String query) async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'music/list',
        queryParameters: {
          'pageNo': '1',
          'pageSize': '20',
          'type': getListTypeAsTabIndex(),
          'keyword': query,
        },
        responseDataKey: ApiConstant.FULL_RESPONSE);
    if (response.isSuccessful) {
      switch (currentlySelectedTab) {
        case 0:
          audioList.value =
              ((response.data as Map<String, dynamic>)['results'] as List)
                  .map((data) => AudioModel.fromMap(data))
                  .toList();
        case 1:
          recentAudioList.value =
              ((response.data as Map<String, dynamic>)['results'] as List)
                  .map((data) => AudioModel.fromMap(data))
                  .toList();
        case 2:
          favoriteAudioList.value =
              ((response.data as Map<String, dynamic>)['results'] as List)
                  .map((data) => AudioModel.fromMap(data))
                  .toList();
          debugPrint('Audio List: ${audioList.value.length}');
        default:
          audioList.value =
              ((response.data as Map<String, dynamic>)['results'] as List)
                  .map((data) => AudioModel.fromMap(data))
                  .toList();
      }
    }
  }

  String getListTypeAsTabIndex() {
    switch (currentlySelectedTab) {
      case 0:
        return 'recommended';
      case 1:
        return 'recent';
      case 2:
        return 'favorite';
      default:
        return 'recommended';
    }
  }

  getAudioListRecommended() async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'music/list',
        queryParameters: {
          'pageNo': '1',
          'pageSize': '20',
          'type': 'recommended',
          // 'keyword': '',
        },
        responseDataKey: ApiConstant.FULL_RESPONSE);
    if (response.isSuccessful) {
      audioList.value =
          ((response.data as Map<String, dynamic>)['results'] as List)
              .map((data) => AudioModel.fromMap(data))
              .toList();
      debugPrint('Audio List: ${audioList.value.length}');
    }
  }

  getAudioListRecent() async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'music/list',
        queryParameters: {
          'pageNo': '1',
          'pageSize': '20',
          'type': 'recent',
          // 'keyword': '',
        },
        responseDataKey: ApiConstant.FULL_RESPONSE);
    if (response.isSuccessful) {
      recentAudioList.value =
          ((response.data as Map<String, dynamic>)['results'] as List)
              .map((data) => AudioModel.fromMap(data))
              .toList();
      debugPrint('Audio List: ${recentAudioList.value.length}');
    }
  }

  getAudioListFavorite() async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'music/list',
        queryParameters: {
          'pageNo': '1',
          'pageSize': '20',
          'type': 'favorite',
          // 'keyword': '',
        },
        responseDataKey: ApiConstant.FULL_RESPONSE);
    if (response.isSuccessful) {
      favoriteAudioList.value =
          ((response.data as Map<String, dynamic>)['results'] as List)
              .map((data) => AudioModel.fromMap(data))
              .toList();
      debugPrint('Audio List: ${favoriteAudioList.value.length}');
    }
  }

  Future<void> addToFavorate(String musicId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'music/make-favorite-music',
      requestData: {
        'music_id': musicId,
      },
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    if (response.isSuccessful) {
      debugPrint('Added to favorite: $musicId');
    }
  }

  _audioScrollListener() {
    if (audioListScrollController.position.pixels > 0 &&
        audioListScrollController.position.pixels /
                audioListScrollController.position.maxScrollExtent <
            0.8) {
      getAudioListRecommended();
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    audioPlayerService = AudioPlayerService();
    audioSearchTextController = TextEditingController();
    audioListScrollController = ScrollController();
    recentAudioListScrollController = ScrollController();
    favoriteAudioListScrollController = ScrollController();
    getAudioListRecommended();
    getAudioListRecent();
    getAudioListFavorite();
    super.onInit();
  }

  @override
  void onReady() {
    audioSearchTextController.addListener(_audioScrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    audioSearchTextController.dispose();

    audioListScrollController.dispose();
    recentAudioListScrollController.dispose();
    favoriteAudioListScrollController.dispose();

    _apiCommunication.endConnection();
    super.onClose();
  }
}
