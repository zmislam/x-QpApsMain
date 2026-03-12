import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/constants/api_constant.dart';
import '../../../data/post_color_list.dart';
import '../../../data/post_local_data.dart';
import '../../../models/event_icon_type_model.dart';
import '../../../models/media_type_model.dart';
import '../../../models/api_response.dart';
import '../../../models/feeling_model.dart';
import '../../../models/friend.dart';
import '../../../models/location_model.dart';
import '../../../models/post.dart';
import '../../../services/api_communication.dart';
import '../../../utils/post_utlis.dart';
import '../../../utils/snackbar.dart';
import '../../NAVIGATION_MENUS/friend/controllers/friend_controller.dart';

class EditPostController extends GetxController {
  late ApiCommunication _apiCommunication;

  RxString eventType = ''.obs;
  RxString eventSubType = ''.obs;
  RxString orgName = ''.obs;
  RxString designation = ''.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxBool is_current_working = false.obs;

  Rx<bool> isBackgroundColorPost = false.obs;

  RxString postId = ''.obs;
  var feelingId = ''.obs;
  var activityId = ''.obs;
  var subActivityId = ''.obs;
  RxString userId = ''.obs;
  RxString postType = 'timeline_post'.obs;
  Rx<Color> postBackgroundColor = postListColor.first.obs;
  var locationId = ''.obs;
  RxString postPrivacy = ''.obs;

  RxBool isLoading = false.obs;

  RxString dropdownValue = privacyList.last.obs;

  TextEditingController descriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  Rx<List<XFile>> xfiles = Rx([]);

  Rx<List<MediaTypeModel>> imageFromNetwork = Rx([]);

  Rx<List<String>> removeMediaId = Rx([]);

  Rx<List<User>> checkFriendList = Rx([]);
  Rx<List<FriendModel>> searchFriendList = Rx([]);

  late FriendController friendController;

  var tagPeopleController = ''.obs;

  var feelingController = ''.obs;
  RxBool isFeelingLoading = false.obs;
  Rx<List<PostFeeling>> feelingList = Rx([]);
  Rx<List<PostFeeling>> feelingSearchList = Rx([]);
  Rx<PostFeeling?> feelingName = Rx(null);
  RxString locationSearch = ''.obs;
  Rx<List<AllLocation>> locationList = Rx([]);
  RxBool isLocationLoading = false.obs;
  Rx<AllLocation?> locationName = Rx(null);

  RxBool isTapped = false.obs;
  Rx<Color> textInputColor = postListColor.first.obs;
  Rx<String> partnerName = 'null'.obs;
  Rx<String> location = 'null'.obs;
  Rx<List<EventIconTypeModel>> eventIconList = Rx([
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Bike.png', iconName: 'Bike'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Birds.png', iconName: 'Birds'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Marriage.png',
        iconName: 'Engagement'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Key.png', iconName: 'Key'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Location.png', iconName: 'Location'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Music.png', iconName: 'Music'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/People.png', iconName: 'People'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Pet.png', iconName: 'Pet'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Running.png', iconName: 'Running'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Smoke.png', iconName: 'Smoke'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Stop.png', iconName: 'Stop'),
    EventIconTypeModel(
        imagePath: 'assets/icon/live_event/Transport.png',
        iconName: 'Transport'),
  ]);
  Rx<String> iconName = 'null'.obs;

  late PostModel postModel;

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    friendController = Get.find();
    postModel = Get.arguments as PostModel;
    getFeeling();
    getLocation('Dhaka');
    friendController.getFriends();
    super.onInit();
  }

  Future<void> updateUserLifeEvent(String userName, String postId) async {
    debugPrint('Update model status code.............' 'funciton call');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'edit-life-event',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'event_type': eventType.value,
        'event_sub_type': eventSubType.value,
        'org_name': orgName.value,
        'designation': designation.value,
        'username': userName,
        'start_date': startDate.value,
        'end_date': endDate.value,
        'post_privacy': postPrivacy.value,
        'post_id': postId,
        'title': titleController.text,
        'icon_name': iconName.value,
        'description': descriptionController.text,
        'location_name': location.value,
        'to_user_id': partnerName.value
      },
    );

    debugPrint(
        'Update model status code.............${apiResponse.statusCode}');

    debugPrint(
        'Update model status success.............${apiResponse.isSuccessful}');

    debugPrint('Update model status  msg.............${apiResponse.message}');

    if (apiResponse.isSuccessful) {
      Get.back();
    } else {}
  }

  String? getBackgroundColor() {
    if (isBackgroundColorPost.value) {
      return postBackgroundColor.value.value.toRadixString(16).substring(2, 8);
    } else {
      return null;
    }
  }

  Future<void> updateUserPost() async {
    List<String> tags = [];

    // Populate tags if there are selected friends
    if (checkFriendList.value.isNotEmpty) {
      tags = checkFriendList.value
          .map((checkFriend) => checkFriend.id.toString())
          .toList();

      debugPrint('Selected friends IDs: $tags');
    }
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'edit-post',
        isFormData: true,
        enableLoading: true,
        requestData: {
          'key' : postModel.key,
          'post_id': postId,
          'description': descriptionController.text,
          'feeling_id': feelingId,
          'activity_id': activityId,
          'sub_activity_id': subActivityId,
          'user_id': userId,
          'post_type': postType,
          'post_background_color': getBackgroundColor(),
          'location_id': locationId,
          'location_name': locationName.value,
          'post_privacy': (getPostPrivacyValue(postPrivacy.value)),
          'tags[]': tags,
          'removable_file_ids[]': removeMediaId.value.toList()
        },
        mediaXFiles: xfiles.value);

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: apiResponse.message ?? 'Error');
    } else {}
  }

  Future<void> updateUserSharePost() async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'edit-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'key' : postModel.key,
        'post_id': postId,
        'description': descriptionController.text,
        'feeling_id': feelingId,
        'activity_id': activityId,
        'sub_activity_id': subActivityId,
        'user_id': userId,
        'post_type': 'Shared',
        'location_id': locationId,
        'location_name': locationName.value,
        'post_privacy': (getPostPrivacyValue(postPrivacy.value)),
        'tags': checkFriendList.value
            .map((checkFriend) => checkFriend.id.toString())
            .toList(),
      },
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: apiResponse.message ?? 'Error');
    } else {}
  }

  Future<void> pickFiles() async {
    isLoading.value = true;
    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();
    for (int index = 0; index < xfiles.value.length; index++) {
      imageFromNetwork.value.add(
          MediaTypeModel(imagePath: xfiles.value[index].path, isFile: true));

      isLoading.value = false;
    }
  }

  Future<void> getFeeling() async {
    isFeelingLoading.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-feelings',
    );
    isFeelingLoading.value = false;

    if (apiResponse.isSuccessful) {
      feelingList.value =
          (((apiResponse.data as Map<String, dynamic>)['postFeelings']) as List)
              .map((element) => PostFeeling.fromJson(element))
              .toList();
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<List<AllLocation>> getLocation(String locationName) async {
    isLocationLoading.value = true;
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'global-search-location?search=$locationName',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    isLocationLoading.value = false;
    if (response.isSuccessful) {
      locationList.value =
          (((response.data as Map<String, dynamic>)['results']) as List)
              .map((element) => AllLocation.fromJson(element))
              .toList();
    } else {
      debugPrint('');
    }
    return locationList.value;
  }
}
