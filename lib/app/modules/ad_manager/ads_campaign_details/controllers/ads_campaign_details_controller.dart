import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../models/ads_management_models/campaign_model.dart';
import '../../../../utils/custom_controllers/file_picker_controller.dart';

class AdsCampaignDetailsController extends GetxController {
  Rx<CampaignModel> campaignModel = Rx(CampaignModel());
  final FilePickerController filePickerController = FilePickerController();

  @override
  void onInit() {
    super.onInit();
    campaignModel.value = Get.arguments as CampaignModel;
    debugPrint(campaignModel.toJson());
    String fileUrl = campaignModel.value.campaignCoverPic!.isEmpty
        ? ''
        : (campaignModel.value.campaignCoverPic?.first ?? '')
            .toString()
            .formatedAdsUrl;
    filePickerController.setNetworkFile(fileUrl: fileUrl);
  }
}
