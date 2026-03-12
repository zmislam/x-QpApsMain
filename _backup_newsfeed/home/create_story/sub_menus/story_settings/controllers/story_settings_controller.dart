import 'package:get/get.dart';

class StorySettingsController extends GetxController {
  Rx<String> privacyGroupValue = 'public'.obs;

  void onChangePrivacy(String? value) {
    privacyGroupValue.value = value ?? privacyGroupValue.value;
  }

  @override
  void onInit() {
    final Map<String, dynamic> data = Get.arguments;
    privacyGroupValue.value = data['selected_privacy'] as String;
    super.onInit();
  }
}
