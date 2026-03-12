import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/api_response.dart';
import '../../../../repository/ads_repository.dart';
import '../../../../routes/app_pages.dart';

import '../../../../models/ads_management_models/campaign_model.dart';
import '../../../../models/ads_management_models/campaign_status_model.dart';

class AdsCampaignHomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  RxString searchText = ''.obs;
  final AdsRepository adsRepository = AdsRepository();

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  RxBool campaignsLoading = true.obs;
  List<CampaignModel> allCampaigns = [];
  List<CampaignModel> userCampaigns = [];

  // ? CORE FUNCTIONS
  void goToCreateCampaignPage() {
    Get.toNamed(Routes.ADS_CAMPAIGN_CREATION);
  }

  void goToCampaignDetailsPage({required CampaignModel dataModel}) {
    Get.toNamed(Routes.ADS_CAMPAIGN_DETAILS, arguments: dataModel);
  }

  Future<void> getAllCampaigns({String? campaignName, String? status, DateTime? startDate, DateTime? endDate, bool? forceFetch, bool? blockLoader}) async {
    userCampaigns.clear();

    // if (blockLoader ?? true) {
    campaignsLoading.value = true;
    // }

    ApiResponse response = await adsRepository.getAllCampaigns(
      campaignName: campaignName,
      endDate: endDate,
      startDate: startDate,
      status: status,
    );

    allCampaigns = response.data as List<CampaignModel>;
    userCampaigns = List.from(allCampaigns);
    filterList();

    campaignsLoading.value = false;
  }

  void filterList() {
    if (tabIndex.value == 0) {
      userCampaigns = List.from(allCampaigns); // All
    } else if (tabIndex.value == 1) {
      userCampaigns = allCampaigns.where((c) => c.status == 'active').toList(); // Active
    } else if (tabIndex.value == 2) {
      userCampaigns = allCampaigns.where((c) => c.status == 'paused').toList(); // Paused
    }

    update();
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  CAMPAIGN FILTER DRAWER FUNCTIONS                                     ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  final searchController = TextEditingController();

  Rx<List<CampaignStatusModel>> campaignStatusList = Rx([]);
  Rx<CampaignStatusModel?> selectedCampaignStatusModel = Rx(null);
  RxBool isCampaignStatusLoading = true.obs;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  RxString startDateValue = ''.obs;
  RxString endDateValue = ''.obs;

  Future<void> getAllCampaignStatus() async {
    // # WE DON'T NEED TO CALL THE STATUS LIST IF WE ALREADY HAVE THE DATA IN HAND
    // # THUS NOT ENABLING THE CACHE SETUP FOR NOW

    if (campaignStatusList.value.isNotEmpty) return;
    isCampaignStatusLoading.value = true;

    ApiResponse apiResponse = await adsRepository.getAllCampaignStatus();
    campaignStatusList.value = List.from(apiResponse.data as List<CampaignStatusModel>);
    isCampaignStatusLoading.value = false;
  }

  Future<void> applyFilterOnCampaignList() async {
    scaffoldKey.currentState!.closeEndDrawer();
    await getAllCampaigns(
      status: selectedCampaignStatusModel.value?.value,
      startDate: startDateValue.value.isNotEmpty ? DateTime.tryParse(startDateValue.value) : null,
      endDate: endDateValue.value.isNotEmpty ? DateTime.tryParse(endDateValue.value) : null,
    );
  }

  void clearFilter() {
    startDateController.clear();
    endDateController.clear();
    startDateValue.value = '';
    endDateValue.value = '';
    selectedCampaignStatusModel = Rx(null);
    isCampaignStatusLoading.value = true;
    isCampaignStatusLoading.value = false;
    update();
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  NAVIGATE TO EDIT THE SELECTED CAMPAIGN                                ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  void editTheSelectedCampaign({required CampaignModel campaignModel}) {
    Get.toNamed(Routes.ADS_CAMPAIGN_CREATION, arguments: campaignModel);
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  DELETE CAMPAIGN WITH ID                                               ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> deleteCampaignWithID({required String id}) async {
    // ? GET AND STORE THE MODEL
    int index = userCampaigns.indexWhere(
      (element) => element.id!.compareTo(id) == 0,
    );
    CampaignModel targetModel = userCampaigns[index];

    // ! PRE REMOVE THE MODEL FOR UI UPDATE
    userCampaigns.remove(targetModel);
    allCampaigns.remove(targetModel);
    refresh();

    // ! CALL THE DELETE API
    ApiResponse response = await adsRepository.deleteCampaign(id: id);

    if (response.isSuccessful) {
      // $ ON SUCCESS CALL A SILENT UPDATE WITH ALL THE FILTER ENABLED
      getAllCampaigns(
        campaignName: searchController.text,
        status: selectedCampaignStatusModel.value?.value,
        startDate: startDateValue.value.isNotEmpty ? DateTime.tryParse(startDateValue.value) : null,
        endDate: endDateValue.value.isNotEmpty ? DateTime.tryParse(endDateValue.value) : null,
        blockLoader: true,
      );
    } else {
      // @ ON FAILURE NOTIFY THE USER AND RESTORE THE OBJECT
      userCampaigns.insert(index, targetModel);
      refresh();
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  CORE STATE FUNCTIONS                                                  ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    getAllCampaignStatus();
    tabController.addListener(
      () {
        tabIndex.value = tabController.index;
        getAllCampaigns(forceFetch: true, blockLoader: false);
      },
    );

    getAllCampaigns(forceFetch: true);
    super.onInit();
  }
}
