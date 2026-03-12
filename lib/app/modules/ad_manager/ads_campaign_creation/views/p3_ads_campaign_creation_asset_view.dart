import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/file_picker_widget.dart';
import '../../../../utils/validator.dart';

import '../../../../components/field_title.dart';
import '../../../../components/text_form_field.dart';
import '../../widgets/ads_creation_navigation_widget.dart';
import '../controllers/ads_campaign_creation_controller.dart';

class AdsCampaignCreationAssetView extends GetView<AdsCampaignCreationController> {
    AdsCampaignCreationAssetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKeyAssets,
      appBar: AppBar(
        title:   Text('Upload Assets'.tr),
      ),

      // ┃ TODO:  IMPLEMENT END DRAWER WHEN DESIGN IS LAVALIERE ┃
      // endDrawer:   Drawer(),

      body: Form(
        key: controller.campaignAssetsFormKey,
        child: ListView(
          padding:   EdgeInsets.all(15),
          children: [
              FieldTitle(title: 'Upload Asset'.tr, isRequired: true),
            FilePickerWidget(controller: controller.filePickerController),
              SizedBox(height: 10),
            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Head Line'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.headlineController,
              hinText: 'Enter your ads headline',
              validator: ValidatorClass().validateHeadline,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Description'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.descriptionController,
              hinText: 'Enter your ads description',
              maxLines: 5,
              validator: ValidatorClass().validateDescription,
            ),
              SizedBox(height: 10),

            // *---------------------------------------------------------------------------
            // * PAGE TO PAGE NAVIGATION
            // *---------------------------------------------------------------------------

              SizedBox(height: 20),
            AdsCreationNavigationWidget(
              actionOneOnClick: () {
                controller.returnToPrevious(pageNumber: 3);
              },
              actionTwoOnClick: () {
                controller.validateAssetsAndGoToConfirm();
              },
            ),
          ],
        ),
      ),
    );
  }
}
