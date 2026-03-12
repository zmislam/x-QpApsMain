import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../ads_campaign_home/controllers/ads_campaign_home_controller.dart';
import '../../../../utils/snackbar.dart';

import '../../../../config/constants/data_const.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/ads_management_models/campaign_model.dart';
import '../../../../models/api_response.dart';
import '../../../../models/location_model.dart';
import '../../../../repository/ads_repository.dart';
import '../../../../repository/utility_repository.dart';
import '../../../../services/api_communication.dart';

class AdsCampaignExtendPageController extends GetxController {
  late ApiCommunication _apiCommunication;
  final LoginCredential loginCredential = LoginCredential();
  final AdsRepository adsRepository = AdsRepository();
  final UtilityRepository utilityRepository = UtilityRepository();

  Rx<CampaignModel?> campaignModel = Rx(null);
  final formKey = GlobalKey<FormState>();

  final totalBudgetController = TextEditingController();
  final dailyBudgetController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final genderController = TextEditingController();
  final maxAgeController = TextEditingController();
  final minAgeController = TextEditingController();

  RxString startDateValue = ''.obs;
  RxString endDateValue = ''.obs;

  var selectedOption = ageSelection.first.obs;

  bool get isAgeRange => selectedOption.value == ageSelection.last;

  void selectOption(String value) {
    selectedOption.value = value;
  }

  void calculateDailyBudget() {
    if (startDateValue.value.isEmpty ||
        endDateValue.value.isEmpty ||
        totalBudgetController.text.isEmpty) {
      dailyBudgetController.text = '0.0';
      return;
    } else if (DateTime.parse(endDateValue.value)
        .isBefore(DateTime.parse(startDateValue.value))) {
      dailyBudgetController.text = '0.0';
      return;
    } else if (DateTime.parse(endDateValue.value)
        .isAtSameMomentAs(DateTime.parse(startDateValue.value))) {
      dailyBudgetController.text = totalBudgetController.text;
      return;
    } else {
      int difference = DateTime.parse(endDateValue.value)
          .difference(DateTime.parse(startDateValue.value))
          .inDays;
      dailyBudgetController.text =
          (num.parse(totalBudgetController.text) / difference)
              .toPrecision(3)
              .toString();
    }
  }

  // *---------------------------------------------------------------------------
  // * CAMPAIGN LOCATION INFO VARs AND FUNCTIONS
  // *---------------------------------------------------------------------------

  final campaignLocationFormKey = GlobalKey<FormState>();

  RxList<String>? enteredKeywords = RxList([]);
  final userDestinationController = TextEditingController();
  final adPlacementController = TextEditingController();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃   GETTING LOCATION WITH SEARCH                                        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Rx<List<AllLocation>> locationList = Rx([]);
  Rx<List<String>> selectedLocations = Rx([]);
  RxBool isLocationLoading = false.obs;

  Future<List<AllLocation>> getLocation(String locationName) async {
    isLocationLoading.value = true;
    final ApiResponse response = await utilityRepository
        .getTargetLocationWithSearch(locationName: locationName);
    isLocationLoading.value = false;
    if (response.isSuccessful) {
      locationList.value = response.data as List<AllLocation>;
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  PREPARE CREATION PAGE FOR EDIT                                       ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  void prepareAllScreenForCreation() {
    if (campaignModel.value == null) return;

    // $ ----------------------------------------------------------------------------------

    genderController.text = campaignModel.value!.gender ?? 'Any';
    maxAgeController.text = campaignModel.value!.toAge.toString();
    minAgeController.text = campaignModel.value!.fromAge.toString();
    selectedOption.value = campaignModel.value?.ageGroup ?? ageSelection.first;

    // $ ----------------------------------------------------------------------------------

    enteredKeywords?.value = campaignModel.value?.keywords ?? [];
    userDestinationController.text = campaignModel.value?.destination ?? '';
    adPlacementController.text = campaignModel.value?.adsPlacement ?? '';
    selectedLocations.value = campaignModel.value?.locations ?? [];
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  RESUBSCRIBE TO CAMPAIGN                                               ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  // id: editReadyCampaignModel.value?.id,
  // adminStatus: 'pending',
  // userId: loginCredential.getUserData().id,
  // campaignName: campaignNameController.text,
  // campaignCategory: campaignCategoryController.text,
  // pageName: selectedMyPageModel.value!.pageName,
  // pageId: selectedMyPageModel.value!.id,
  // startDate: DateTime.tryParse(startDateValue.value),
  // endDate: DateTime.tryParse(endDateValue.value),
  // callToAction: callToActionController.text,
  // websiteUrl: userDestinationController.text,
  // // ! THIS MAY NEED CHANGE
  // totalBudget: totalBudgetController.text.isNotEmpty ? double.tryParse(totalBudgetController.text) : null,
  // dailyBudget: double.tryParse(dailyBudgetController.text),
  // gender: genderController.text,
  // headline: headlineController.text,
  // description: descriptionController.text,
  // adsPlacement: adPlacementController.text,
  // destination: userDestinationController.text,
  // ageGroup: selectedOption.value,
  // fromAge: int.tryParse(minAgeController.text),
  // toAge: int.tryParse(maxAgeController.text),
  // locations: selectedLocations.value,
  // keywords: enteredKeywords ?? [],
  // status: status,

  Future<void> resubscribeToCampaignAndRunAds() async {
    if (formKey.currentState!.validate()) {
      final response = await adsRepository.saveCampaignSubscription(
        campaignId: campaignModel.value!.id.toString(),
        startDate: DateTime.tryParse(startDateValue.value) ?? DateTime.now(),
        endDate: DateTime.tryParse(endDateValue.value) ?? DateTime.now(),
        totalBudget: totalBudgetController.text.isNotEmpty
            ? double.tryParse(totalBudgetController.text)
            : null,
        dailyBudget: double.tryParse(dailyBudgetController.text),
        websiteUrl: userDestinationController.text,
        adsPlacement: adPlacementController.text,
        ageGroup: selectedOption.value,
        fromAge: int.tryParse(minAgeController.text),
        toAge: int.tryParse(maxAgeController.text),
        locations: selectedLocations.value,
        keywords: enteredKeywords ?? [],
        gender: genderController.text,
      );

      if (response.isSuccessful) {
        final adsCampaignHomeController = Get.find<AdsCampaignHomeController>();
        adsCampaignHomeController.getAllCampaigns(blockLoader: false);

        showSuccessSnackkbar(
            message: response.message ?? 'Run Ads Successfully');
      } else {
        showErrorSnackkbar(message: response.message ?? 'Run Ads Failed');
      }
    } else {
      debugPrint('VALIDATION FAILED');
    }
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  Core INIT FUNCTION                                                   ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    campaignModel.value = Get.arguments as CampaignModel;
    prepareAllScreenForCreation();
    super.onInit();
  }
}
