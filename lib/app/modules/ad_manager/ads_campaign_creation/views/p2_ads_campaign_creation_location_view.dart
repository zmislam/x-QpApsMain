import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/data_const.dart';

import '../../../../components/dropdown.dart';
import '../../../../components/field_title.dart';
import '../../../../components/text_form_field.dart';
import '../../../../models/location_model.dart';
import '../../../../utils/validator.dart';
import '../../widgets/ads_creation_navigation_widget.dart';
import '../controllers/ads_campaign_creation_controller.dart';

class AdsCampaignCreationLocationView extends GetView<AdsCampaignCreationController> {
    AdsCampaignCreationLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKeyLocation,
      appBar: AppBar(
        title:   Text('Location'.tr),
      ),

      // ┃ TODO:  IMPLEMENT END DRAWER WHEN DESIGN IS LAVALIERE ┃
      // endDrawer:   Drawer(),

      body: Form(
        key: controller.campaignLocationFormKey,
        child: ListView(
          padding:   EdgeInsets.all(15),
          children: [
              FieldTitle(title: 'Search For Location'.tr, isRequired: false),
            BottomSheetDropdownMultiSelect<String>(
              list: controller.locationList.value
                  .map(
                    (e) => e.locationName.toString(),
                  )
                  .toList(), //  [],
              onChanged: (object) {
                controller.selectedLocations.value = object;
              },
              selectedItems: controller.selectedLocations.value,
              minLengthForSearch: 1,
              hint: 'Search Location',
              onSearch: (String searchText) async {
                controller.locationList.value.clear();
                debugPrint('Searching: $searchText');
                List<AllLocation> locations = await controller.getLocation(searchText);
                List<String> locationNames = locations.map((location) => location.locationName).whereType<String>().toList();
                return locationNames;
              },
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Call To Action Button'.tr, isRequired: true),
            PrimaryDropDownField(
              hint: 'Select action button type',
              list: callToActionOptions,
              validationText: 'Please select a type',
              onChanged: (value) {
                controller.callToActionController.text = value ?? '';
              },
              value: controller.callToActionController.text.isEmpty ? null : controller.callToActionController.text,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Keyword'.tr, isRequired: true),
            MultiInputChipField(
              label: 'Keywords'.tr,
              hintText: 'Add a keyword and press done'.tr,
              validator: ValidatorClass().validateListNotEmpty,
              itemsRx: controller.enteredKeywords, // Pass the RxList to maintain state
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'User Destination'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.userDestinationController,
              hinText: 'www.example.qp.com',
              prefixIcon:   Icon(Icons.link),
              keyboardInputType: TextInputType.url,
              validator: ValidatorClass().validateUrl,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Ads Placement'.tr, isRequired: true),
            PrimaryDropDownField(
              hint: 'Select ad placement location',
              list: adsPlacementOptions,
              validationText: 'Please select a location',
              onChanged: (value) {
                controller.adPlacementController.text = value ?? '';
              },
              value: controller.adPlacementController.text.isEmpty ? null : controller.adPlacementController.text,
            ),
              SizedBox(height: 10),

            // *---------------------------------------------------------------------------
            // * PAGE TO PAGE NAVIGATION
            // *---------------------------------------------------------------------------

              SizedBox(height: 20),
            AdsCreationNavigationWidget(
              actionOneOnClick: () {
                controller.returnToPrevious(pageNumber: 2);
              },
              actionTwoOnClick: () {
                controller.validateLocationAndGoToAssets();
              },
            ),
          ],
        ),
      ),
    );
  }
}
