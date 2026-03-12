import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/api_response.dart';
import '../../../models/location_model.dart';
import '../../../services/api_communication.dart';
import '../../../utils/snackbar.dart';

class BoostPostController extends GetxController {
  late ApiCommunication _apiCommunication;
  late TextEditingController campaignNameController;
  late TextEditingController fromDateController;
  late TextEditingController endDateController;
  late TextEditingController totalBudgetController;
  late TextEditingController dailyBudgetController;
  late TextEditingController destinationController;

  Rx<String?> postId = Rx(null);

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

  void selectDate(BuildContext context, RxString dateValue,
      TextEditingController controller) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child:   Text('Cancle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
          title:   Text('Date Picker'.tr,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          content: SizedBox(
            width: 400,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(1950, 1, 1),
              lastDate: DateTime(2050, 1, 1),
              onDateChanged: (DateTime newDate) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
                if (controller == fromDateController) {
                  fromDate.value = formattedDate;
                } else {
                  endDate.value = formattedDate;
                }

                dateValue.value = newDate.toIso8601String();
                controller.text = formattedDate;

                debugPrint('Updated Date: $formattedDate');
                Navigator.pop(context); // Close dialog after selection
              },
            ),
          ),
        );
      },
    );
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
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  // Required variables

  String selectedCampaignCategory = '';
  String ageGroup = 'allAges';
  RangeValues rangeValues =   RangeValues(1, 100);
  String onCLocationChanged = '';
  String onKeyWordsChanged = '';
  String onGenderChanged = '';

  Future<void> saveBoostPost() async {
    Map<String, dynamic> data = {
      'post_id': postId.value,
      'campaign_name': campaignNameController.text.trim(),
      'campaign_category': selectedCampaignCategory,
      'start_date': fromDate.value.toString(),
      'end_date': endDate.value.toString(),
      'total_budget': num.parse(totalBudgetController.text),
      'daily_budget': num.parse(dailyBudgetController.text),
      'age_group': ageGroup,
      'gender': onGenderChanged == 'All' ? 'Any' : onGenderChanged,
      'locations': onCLocationChanged, // onCLocationChanged,
      'keywords': onKeyWordsChanged,
      'destination': destinationController.text.startsWith('http')
          ? destinationController.text
          : 'https://${destinationController.text}',
      'ads_placement': 'Newsfeed Ads',
      'media': []
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
      showSuccessSnackkbar(message: 'Post Boosted Successfully');
    } else {
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
    postId.value = Get.arguments;

    everAll([fromDate, endDate, totalBudget], (_) => calculateDailyBudget());
  }

  @override
  void onClose() {
    super.onClose();
    _apiCommunication.endConnection();
  }
}
