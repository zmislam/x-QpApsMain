import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../../../models/social_media_model.dart';
import '../../../../../../../../../../models/websites.dart';
import '../../../../../../../../../../config/constants/color.dart';
import '../../../../../../../../../../components/edit_profile/privacy_model.dart';
import '../../../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../../../models/api_response.dart';
import '../../../../../../../../../../models/user.dart';
import '../../../controller/about_controller.dart';
import '../../../../../../../../../../services/api_communication.dart';

class AddWebsiteController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController linkAddressController;
  AboutController aboutcontroller = Get.find();
  Websites? websites;
  RxList<SocialMediaModel> socialMediaList = <SocialMediaModel>[].obs;
  Rx<SocialMediaModel?> selectedSocialMediaType = Rx(null);
  AboutController aboutController = Get.find();

  Rx<bool> isStudying = false.obs;
  Rx<PrivacySearchModel?> privacyModel = Rx(null);
/*=============== ADD Websites API=====================*/
  Future<void> onTapAddWebsitePatch({String? websiteId}) async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'upsert-user-website',
      isFormData: false,
      enableLoading: true,
      requestData: {
        'social_media_id':
      websites?.social_media_id ?? selectedSocialMediaType.value?.id,
        'website_url': linkAddressController.text,
        'privacy': getPrivacyDescription(privacyModel.value?.privacy ?? 'public'),
      ((websiteId?.isEmpty)??false) ?
      'website_id': websiteId??'':null
      },
    );
    if (response.isSuccessful) {
      await aboutController.getUserALLData();
      Get.back();
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

// DropDown Social Media Api
  Future<void> fetchSocialMediaOptions() async {
    final ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-social-media',
      responseDataKey: 'socialMedia',
    );

    if (response.isSuccessful) {
      var data = response.data;
      if (data != null && data is List<dynamic>) {
        socialMediaList.value =
            data.map((json) => SocialMediaModel.fromMap(json)).toList();
        if (socialMediaList.isNotEmpty) {
          // contactDropdownalue.value = socialMediaList.first.media_name ?? '';
        }
      } else {
        socialMediaList.value = [];
        debugPrint('API returned null or unexpected data format.');
      }
    } else {
      debugPrint('API ERROR: ${response.message}');
    }
  }

  void setSelectedDropdownValue(SocialMediaModel? value) {
    selectedSocialMediaType.value = value;
  }

  void setSelectedSocialMediaDropdownValueAsWebsite(Websites website) {
// selectedSocialMediaType.value = website.socialMedia;
    getPrivacyDescription(privacyModel.value?.privacy ?? 'public');

    for (SocialMediaModel socialMediaModel in socialMediaList) {
      if (socialMediaModel.media_name == website.socialMedia?.media_name) {
        selectedSocialMediaType.value = socialMediaModel;
      }
    }
  }

  PrivacySearchModel getPrivacyModel(String privacy) {
    switch (privacy) {
      case 'public':
        return PrivacySearchModel(id: '1', privacy: 'public');
      case 'friends':
        return PrivacySearchModel(id: '2', privacy: 'friends');
      case 'only_me':
        return PrivacySearchModel(id: '3', privacy: 'only_me');
      case 'only me':
        return PrivacySearchModel(id: '3', privacy: 'only_me');
      default:
        return PrivacySearchModel(id: '1', privacy: 'public');
    }
  }

 
  String getPrivacyDescription(String privacy) {
    switch (privacy) {
      case 'public':
        return 'public';
      case 'friends':
        return 'friends';
      case 'only_me':
        return 'only me';
      default:
        return 'public';
    }
  }

  Future<List<PrivacySearchModel>> getData(String filter) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, dynamic>> jsonData = [
      {
        'id': '1',
        'privacy': 'public',
      },
      {
        'id': '2',
        'privacy': 'friends',
      },
      {
        'id': '3',
        'privacy': 'only_me',
      },
    ];

    // Filtering the data based on the filter
    List<PrivacySearchModel>? filteredData =
        PrivacySearchModel.fromJsonList(jsonData)?.where((model) {
      return model.privacy?.toLowerCase().contains(filter.toLowerCase()) ??
          false;
    }).toList();

    return filteredData ?? List.empty();
  }

  Icon getIconForPrivacy(bool isPrivacySelected, String privacy) {
    isPrivacySelected = false;
    switch (privacy) {
      case 'public':
        return const Icon(Icons.public, color: PRIMARY_COLOR);
      case 'friends':
        return const Icon(Icons.group, color: PRIMARY_COLOR);
      case 'only_me':
        return const Icon(Icons.lock, color: PRIMARY_COLOR);
      default:
        return const Icon(Icons.help_outline);
    }
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    linkAddressController = TextEditingController();

    await fetchSocialMediaOptions();

    websites = Get.arguments;
    if (websites != null) {
      linkAddressController.text = websites?.website_url ?? '';
      privacyModel.value = getPrivacyModel(websites?.privacy ?? 'public');

      setSelectedSocialMediaDropdownValueAsWebsite(websites!);
      // getPrivacyDescription(privacyModel?.privacy ?? 'public');
    } else {
      if (socialMediaList.isNotEmpty) {
        selectedSocialMediaType.value = socialMediaList.first;
      }
    }
    userModel = _loginCredential.getUserData();
    super.onInit();
  }

  @override
  void onReady() {
    aboutController;
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
