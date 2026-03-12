import 'dart:io';

import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/merge_story.dart';
import '../models/story.dart';
import '../services/api_communication.dart';

class StoryRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  CREATE STORY                                                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> createStory({required Map<String, dynamic>? data, required List<File>? files}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-story',
      isFormData: true,
      requestData: data,
      mediaFiles: files,
      enableLoading: true,
    );
    return apiResponse;
  }

  Future<List<StoryMergeModel>> getAllStory({bool? forceRecallAPI}) async {
    List<StoryMergeModel> allStoryList = [];
    allStoryList.clear();
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-all-story',
      responseDataKey: 'results',
      enableCache: true,
      timeToLiveInSeconds: 60 * 10, // 10 m cached,
      forceRecallAPI: forceRecallAPI,
    );
    if (response.isSuccessful) {
      allStoryList = (response.data as List).map((e) => StoryMergeModel.fromMap(e)).toList();
    }
    return allStoryList;
  }

  Future<bool> storyViewed({
    required String userId,
    required String storyId,
  }) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-story-view',
      requestData: {
        'user_id': userId,
        'story_id': storyId,
      },
    );

    if (apiResponse.isSuccessful) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> doReactionOnStory({
    required String userId,
    required String storyId,
    required String reactionType,
  }) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(apiEndPoint: 'save-story-reaction', enableLoading: false, requestData: {'user_id': userId, 'storyId': storyId, 'reactionType': reactionType});

    if (apiResponse.isSuccessful) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteStory(String storyId) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-story',
      requestData: {
        'storyId': storyId,
      },
    );
    if (apiResponse.isSuccessful) {
      return true;
    } else {
      return false;
    }
  }

  /// Fetch full story data for a specific story ID (used by story suggestion cards).
  ///
  /// Calls `POST /get-user-story` with `{ story_id }` and returns a list of
  /// [StoryMergeModel] with the tapped story's user's stories.
  Future<List<StoryMergeModel>> getUserStoryById({required String storyId}) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-user-story',
      requestData: {'story_id': storyId},
      responseDataKey: 'results',
      enableLoading: false,
    );

    if (apiResponse.isSuccessful && apiResponse.data is List) {
      return (apiResponse.data as List)
          .map((e) => StoryMergeModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return [];
  }

//! ========================================================== Unused Api Calls

  Future<List<StoryModel>> getStories() async {
    List<StoryModel> storytList = [];
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-story',
    );

    if (apiResponse.isSuccessful) {
      storytList = (((apiResponse.data as Map<String, dynamic>)['results']) as List).map((element) => StoryModel.fromMap(element)).toList();
    }
    return storytList;
  }

  Future<StoryMergeModel?> getSingleStory(String storyId) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'single-story',
      requestData: {
        'story_id': storyId,
      },
      responseDataKey: 'results',
    );
    if (apiResponse.isSuccessful) {
      StoryMergeModel storyMergeModel = StoryMergeModel.fromMap((apiResponse.data as List)[0]);
      return storyMergeModel;
    } else {
      return null;
    }
  }

  //! Unused Api Calls  ==========================================================
}
