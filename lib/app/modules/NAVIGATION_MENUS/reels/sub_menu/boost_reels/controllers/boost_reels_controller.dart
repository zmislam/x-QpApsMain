
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/snackbar.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../models/location_model.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../services/api_communication.dart';

class BoostReelsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late TextEditingController campaignNameController;
  late TextEditingController fromDateController;
  late TextEditingController endDateController;
  late TextEditingController totalBudgetController;
  late TextEditingController dailyBudgetController;
  late TextEditingController destinationController;
  // Rx<ReelsModel> reelsModel = ReelsModel().obs;
  RxString reelId = ''.obs;
  final formKey = GlobalKey<FormState>();
  var campaignCategoryList = [
    'Technology',
    'Fashion',
    'Health',
    'Education',
    'Entertainment',
    'Sports',
    'Travel',
    'Food',
    'Other'
  ];
  var genderList = ['All', 'Male', 'Female'];
  var keywordsList = [
    'PSL',
    'PakizaSoftwareLimited',
    'PTVL',
    'Pakiza',
    'BlockChain'
  ];
  var fromDate = ''.obs;
  var endDate = ''.obs;
  var totalBudget = 0.0.obs; // Total budget as a double
  var dailyBudget = 0.0.obs;
  VideoPlayerController? videoPlayerController;
  var selectedGender = ''.obs;
  var searchGenderQuery = ''.obs;

//==========================================Generate video thumbnail===============================================//
  Future<String?> generateThumbnail(String videoPath) async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse((videoPath)))
          ..initialize().then((_) {});
    return videoPath;
  }

  void selectDate(BuildContext context, RxString dateValue,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (controller == fromDateController) {
        fromDate.value = formattedDate;
      } else {
        endDate.value = formattedDate;
      }

      dateValue.value = pickedDate.toIso8601String();
      controller.text = formattedDate;

      debugPrint('Updated Date: $formattedDate');
    }
  }

// KeyWord Search
  var selectedKeywords = <String>[].obs;
  TextEditingController keywordController = TextEditingController();
  void addKeyword(String keyword) {
    if (keyword.isNotEmpty && !selectedKeywords.contains(keyword)) {
      selectedKeywords.add(keyword);
    }
    keywordController.clear();
  }

  void removeKeyword(String keyword) {
    selectedKeywords.remove(keyword);
  }

  /// Function to calculate daily budget
  void calculateDailyBudget() {
    if (fromDate.value.isNotEmpty &&
        endDate.value.isNotEmpty &&
        totalBudget.value > 0) {
      try {
        DateTime start = DateFormat('yyyy-MM-dd').parse(fromDate.value);
        DateTime end = DateFormat('yyyy-MM-dd').parse(endDate.value);
        int days = end.difference(start).inDays + 1;

        if (days > 0) {
          dailyBudget.value = totalBudget.value / days;
          dailyBudgetController.text = dailyBudget.value.toStringAsFixed(2);
        } else {
          dailyBudget.value = 0;
          dailyBudgetController.text = '0.00';
        }
      } catch (e) {
        dailyBudget.value = 0;
        dailyBudgetController.text = '0.00';
      }
    } else {
      dailyBudget.value = 0;
      dailyBudgetController.text = '0.00';
    }
  }

  bool isValidURL(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  Rx<List<AllLocation>> locationList = Rx([]);
  var locationId = ''.obs;
  Rx<AllLocation?> selectedLocation = Rx(null);

  RxBool isLocationLoading = false.obs;

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

      update();
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  Future<List<AllLocation>> getFutureLocation(String locationName) async {
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

      update();
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

// Future<List<String>> getLocation(String locationName) async {
//   isLocationLoading.value = true;

//   final ApiResponse response = await _apiCommunication.doGetRequest(
//     apiEndPoint: 'global-search-location?search=$locationName',
//     responseDataKey:' ApiConstant.FULL_RESPONSE,'
//   );

//   isLocationLoading.value = false;

//   if (response.isSuccessful) {
//     // Ensure response.data is a Map before parsing
//     if (response.data is Map<String, dynamic>) {
//       LocationModel locationModel = LocationModel.fromJson(response.data as Map<String, dynamic>);

//       // Extract `locationName` from `AllLocation`
//       return locationModel.allLocation?.map((location) => location.locationName ?? '').toList() ?? [];
//     } else {
//       debugPrint('Error: Expected Map<String, dynamic>, got ${response.data.runtimeType}');
//       return [];
//     }
//   } else {
//     return []; // Return an empty list if API request fails
//   }
// }

  // Required variables

  String selectedCampaignCategory ='Technology';
  String ageGroup = 'allAges';
  RangeValues rangeValues = const RangeValues(16, 100);
  String onCLocationChanged = '';
  String onKeyWordsChanged = '';
  String onGenderChanged = 'All';

  Future<void> saveBoostPost() async {
    Map<String, dynamic> data = {
      'reel_id': reelId.value,
      'campaign_name': campaignNameController.text.trim(),
      'campaign_category': selectedCampaignCategory,
      'start_date': fromDate.value.toString(),
      'end_date': endDate.value.toString(),
      'total_budget': num.parse(totalBudgetController.text),
      'daily_budget': num.parse(dailyBudgetController.text),
      'media':'',
      'age_group': ageGroup, // ["allAges","ageRange"]

      'gender': onGenderChanged == 'All' ? 'Any' : onGenderChanged,
      'locations': onCLocationChanged, // onCLocationChanged,
      'keywords': 
        selectedKeywords.map((e)=>e.toString()).toList()
      , // keywords = ["PSL", "PakizaSoftwareLimited", "PTVL", "Pakiza", "BlockChain"];
      'destination': destinationController.text.startsWith('http')
          ? destinationController.text
          : 'https://${destinationController.text}',
      'ads_placement': 'Reels Ads',
    };

    if (ageGroup.compareTo('ageRange') == 0) {
      data.addAll({
        'from_age': rangeValues.start,
        'to_age': rangeValues.end,
      });
    }

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'pages/save-boost',
      requestData: data,
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Reel Boosted Successfully');
    } else {
Get.until((route)=>route.settings.name ==Routes.TAB);
       
      // showSuccessSnackkbar(message: 'Reel Boosted Successfully');
      showErrorSnackkbar(message: '${apiResponse.message}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _apiCommunication = ApiCommunication();
    totalBudgetController = TextEditingController();

    dailyBudgetController = TextEditingController();
    campaignNameController = TextEditingController();
    fromDateController = TextEditingController();
    endDateController = TextEditingController();

    destinationController = TextEditingController();
    reelId.value = Get.arguments;

    everAll([fromDate, endDate, totalBudget], (_) => calculateDailyBudget());
  }

  @override
  void onClose() {
    super.onClose();
    _apiCommunication.endConnection();
  }
}
