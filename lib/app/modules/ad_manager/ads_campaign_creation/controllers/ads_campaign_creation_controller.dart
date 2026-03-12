import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../models/ads_management_models/campaign_model.dart';
import '../../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/mypage_model.dart';
import '../../../../repository/ads_repository.dart';
import '../../../../repository/page_repository.dart';
import '../../../../repository/utility_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/custom_controllers/file_picker_controller.dart';

import '../../../../config/constants/data_const.dart';
import '../../../../models/api_response.dart';
import '../../../../models/location_model.dart';
import '../../../../services/api_communication.dart';
import '../../ads_campaign_home/controllers/ads_campaign_home_controller.dart';

class AdsCampaignCreationController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKeyLocation = GlobalKey<ScaffoldState>();
  final scaffoldKeyAssets = GlobalKey<ScaffoldState>();
  final scaffoldKeyConfirm = GlobalKey<ScaffoldState>();

  late ApiCommunication _apiCommunication;
  final LoginCredential loginCredential = LoginCredential();
  final AdsRepository adsRepository = AdsRepository();
  final PageRepository pageRepository = PageRepository();
  final UtilityRepository utilityRepository = UtilityRepository();

  // *---------------------------------------------------------------------------
  // * CAMPAIGN GENERAL INFO VARs AND FUNCTIONS
  // *---------------------------------------------------------------------------

  final campaignDetailsFormKey = GlobalKey<FormState>();
  final campaignNameController = TextEditingController();
  final campaignCategoryController = TextEditingController();
  Rx<MyPagesModel?> selectedMyPageModel = Rx(null);
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
    if (startDateValue.value.isEmpty || endDateValue.value.isEmpty || totalBudgetController.text.isEmpty) {
      dailyBudgetController.text = '0.0';
      return;
    } else if (DateTime.parse(endDateValue.value).isBefore(DateTime.parse(startDateValue.value))) {
      dailyBudgetController.text = '0.0';
      return;
    } else if (DateTime.parse(endDateValue.value).isAtSameMomentAs(DateTime.parse(startDateValue.value))) {
      dailyBudgetController.text = totalBudgetController.text;
      return;
    } else {
      int difference = DateTime.parse(endDateValue.value).difference(DateTime.parse(startDateValue.value)).inDays;
      dailyBudgetController.text = (num.parse(totalBudgetController.text) / difference).toPrecision(3).toString();
    }
  }

  // @ SETTING UP PAGE SELECTION FOR CAMPAIGN CREATION
  Rx<List<MyPagesModel>> myPages = Rx([]);
  RxBool loadingMyPages = true.obs;

  Future<void> getMyPages() async {
    loadingMyPages.value = true;
    myPages.value.clear();
    ApiResponse apiResponse = await pageRepository.getMyPages(skip: 0, forceFetch: true);
    myPages.value = List.from(apiResponse.data as List<MyPagesModel>);
    loadingMyPages.value = false;
    refresh();

    // ? CALL THE PREPARE FOR EDIT METHOD FOR PAGE
    prepareMyPageSelectionForEdit();
  }

  // *---------------------------------------------------------------------------
  // * CAMPAIGN LOCATION INFO VARs AND FUNCTIONS
  // *---------------------------------------------------------------------------

  final campaignLocationFormKey = GlobalKey<FormState>();

  final callToActionController = TextEditingController();
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
    final ApiResponse response = await utilityRepository.getTargetLocationWithSearch(locationName: locationName);
    isLocationLoading.value = false;
    if (response.isSuccessful) {
      locationList.value = response.data as List<AllLocation>;
    } else {
      debugPrint('');
    }
    return locationList.value;
  }

  // *---------------------------------------------------------------------------
  // * CAMPAIGN ASSETS INFO VARs AND FUNCTIONS
  // *---------------------------------------------------------------------------

  final campaignAssetsFormKey = GlobalKey<FormState>();

  final headlineController = TextEditingController();
  final descriptionController = TextEditingController();
  final FilePickerController filePickerController = FilePickerController();

  // *---------------------------------------------------------------------------
  // * CAMPAIGN CREATION CONFIRM INFO VARs AND FUNCTIONS
  // *---------------------------------------------------------------------------

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CORE NAVIGATION AND VALIDATION FUNCTIONS                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  // $ KEEPING THE PAGE NUMBER FOR LATER USER IF NEEDED
  void returnToPrevious({required int pageNumber}) {
    Get.back();
  }

  void validateCampaignDetailsAndGoToLocation() {
    if (campaignDetailsFormKey.currentState!.validate()) {
      Get.toNamed(Routes.ADS_CAMPAIGN_CREATION_LOCATION);
    }
  }

  void validateLocationAndGoToAssets() {
    if (campaignLocationFormKey.currentState!.validate()) {
      Get.toNamed(Routes.ADS_CAMPAIGN_CREATION_ASSETS);
    }
  }

  void validateAssetsAndGoToConfirm() {
    if (campaignAssetsFormKey.currentState!.validate() && (filePickerController.hasFile || filePickerController.hasNetworkFile)) {
      Get.toNamed(Routes.ADS_CAMPAIGN_CREATION_CONFIRM);
      filePickerController.hideErrorMessage();
    } else if (!filePickerController.hasFile || !filePickerController.hasNetworkFile) {
      filePickerController.validate(required: true);
    }
  }

  void editCampaignDetailsPage() {
    Get.back();
    Get.back();
    Get.back();
  }

  void editCampaignLocationPage() {
    Get.back();
    Get.back();
  }

  void editCampaignAssetPage() {
    Get.back();
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  PREPARE CREATION PAGE FOR EDIT                                       ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Rx<CampaignModel?> editReadyCampaignModel = Rx(null);

  void prepareAllScreenForCreation() {
    if (editReadyCampaignModel.value == null) return;

    // $ ----------------------------------------------------------------------------------

    campaignNameController.text = editReadyCampaignModel.value?.campaignName ?? '';
    campaignCategoryController.text = editReadyCampaignModel.value?.campaignCategory ?? '';
    totalBudgetController.text = editReadyCampaignModel.value!.totalBudget.toString();
    dailyBudgetController.text = editReadyCampaignModel.value!.dailyBudget.toString();
    startDateController.text = editReadyCampaignModel.value!.startDate != null ? DateFormat().add_MMMEd().format(editReadyCampaignModel.value!.startDate!) : '';
    endDateController.text = editReadyCampaignModel.value!.endDate != null ? DateFormat().add_MMMEd().format(editReadyCampaignModel.value!.endDate!) : '';
    genderController.text = editReadyCampaignModel.value!.gender ?? 'Any';
    maxAgeController.text = editReadyCampaignModel.value!.toAge.toString();
    minAgeController.text = editReadyCampaignModel.value!.fromAge.toString();

    startDateValue.value = editReadyCampaignModel.value!.startDate != null ? editReadyCampaignModel.value!.startDate!.toIso8601String() : '';
    endDateValue.value = editReadyCampaignModel.value!.endDate != null ? editReadyCampaignModel.value!.endDate!.toIso8601String() : '';
    selectedOption.value = editReadyCampaignModel.value?.ageGroup ?? ageSelection.first;

    // $ ----------------------------------------------------------------------------------

    callToActionController.text = editReadyCampaignModel.value?.callToAction ?? '';
    enteredKeywords?.value = editReadyCampaignModel.value?.keywords ?? [];
    userDestinationController.text = editReadyCampaignModel.value?.destination ?? '';
    adPlacementController.text = editReadyCampaignModel.value?.adsPlacement ?? '';
    selectedLocations.value = editReadyCampaignModel.value?.locations ?? [];
    // $ ----------------------------------------------------------------------------------

    filePickerController.setNetworkFile(fileUrl: editReadyCampaignModel.value!.campaignCoverPic!.isEmpty ? '' : (editReadyCampaignModel.value!.campaignCoverPic!.first.toString().formatedAdsUrl));
    headlineController.text = editReadyCampaignModel.value?.headline ?? '';
    descriptionController.text = editReadyCampaignModel.value?.description ?? '';
  }

  // # THE DATA COMES FROM API THUS WE NEED TO UPDATE THE SELECTION SATE AFTER THE COMPLETION OF API CALL
  void prepareMyPageSelectionForEdit() {
    if (editReadyCampaignModel.value == null) return;

    selectedMyPageModel.value = myPages.value.firstWhere(
      (element) => element.id == editReadyCampaignModel.value?.pageId,
    );
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  CREATE OR EDIT CAMPAIGN BASED ON IF CAMPAIGN MODEL WAS PASSED        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> createCampaign({required String status}) async {
    final CampaignModel campaignModel = CampaignModel(
      id: editReadyCampaignModel.value?.id,
      adminStatus: 'pending',
      userId: loginCredential.getUserData().id,
      campaignName: campaignNameController.text,
      campaignCategory: campaignCategoryController.text,
      pageName: selectedMyPageModel.value!.pageName,
      pageId: selectedMyPageModel.value!.id,
      startDate: DateTime.tryParse(startDateValue.value),
      endDate: DateTime.tryParse(endDateValue.value),
      callToAction: callToActionController.text,
      websiteUrl: userDestinationController.text,
      // ! THIS MAY NEED CHANGE
      totalBudget: totalBudgetController.text.isNotEmpty ? double.tryParse(totalBudgetController.text) : null,
      dailyBudget: double.tryParse(dailyBudgetController.text),
      gender: genderController.text,
      headline: headlineController.text,
      description: descriptionController.text,
      adsPlacement: adPlacementController.text,
      destination: userDestinationController.text,
      ageGroup: selectedOption.value,
      fromAge: int.tryParse(minAgeController.text),
      toAge: int.tryParse(maxAgeController.text),
      locations: selectedLocations.value,
      keywords: enteredKeywords ?? [],
      status: status,
    );

    // * GOING FOR EDIT
    if (editReadyCampaignModel.value != null) {
      // @ HANDEL IF THE FILE HAS CHANGED OR NOT
      List<String> files = [];
      if (filePickerController.processedFileData.isNotEmpty) {
        files.add(filePickerController.processedFileData.first);
      }
      await adsRepository.editCampaign(campaignModel: campaignModel, files: files);
    }
    // ? GOING FOR CREATION
    else {
      await adsRepository.createNewCampaign(campaignModel: campaignModel, files: filePickerController.processedFileData);
    }
    final adsCampaignHomeController = Get.find<AdsCampaignHomeController>();
    await adsCampaignHomeController.getAllCampaigns();
    Get.back();
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  CORE STATE                                                            ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();

    // * GET THE CAMPAIGN MODEL FOR EDIT IF PASSED
    if (Get.arguments != null) {
      // * SET THE MODEL
      editReadyCampaignModel.value = Get.arguments as CampaignModel;
    }
    getMyPages();
    getLocation('');

    prepareAllScreenForCreation();
    super.onInit();
  }
}
