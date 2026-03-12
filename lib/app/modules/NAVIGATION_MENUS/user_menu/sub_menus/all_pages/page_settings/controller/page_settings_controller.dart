import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../services/api_communication.dart';
import '../../page_profile/model/page_profile_model.dart';

class PageSettingsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;

  final GlobalKey<FormState> formKey = GlobalKey();

  late TextEditingController pageNameController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController whatsAppNumberController;

  Rx<PageProfileModel?> pageProfileModel = Rx(null);

  var isSaveButtonEnabled = false.obs;

  // String? pageUserName;

  // //=========================================== Edit Page =================================================//

  // Future<void> editPage(String pageId) async {
  //   final ApiResponse response = await _apiCommunication.doPatchRequest(
  //     apiEndPoint: 'pages/edit-page/$pageId',
  //     enableLoading: true,
  //     requestData: {
  //       'bio': descriptionController.text,
  //       'email': emailController.text,
  //       'location': locationController.text,
  //       'name': pageNameController.text,
  //       'phone_number': phoneNumberController.text,
  //       'website': websiteController.text,
  //       'whatsapp_number': whatsAppNumberController.text,
  //     },
  //   );
  //   if (response.isSuccessful) {
  //     Get.back();

  //     showSuccessSnackkbar(message: 'Pages updated successfully');
  //   } else {
  //     debugPrint('');
  //   }
  // }

  // Future<void> deletePage(String pageId) async {
  //   final ApiResponse response = await _apiCommunication
  //       .doPostRequest(apiEndPoint: 'delete-page', requestData: {
  //     '_id': pageId,
  //   });
  //   if (response.isSuccessful) {
  //     pageProfileModel;

  //     Get.back();
  //     Get.back();
  //     Get.back();
  //     showSuccessSnackkbar(message: 'Page deleted successfully');
  //   } else {
  //     debugPrint('');
  //   }
  // }

//=========================================== Delete Page =================================================//

  // Future<void> deletePage(String pageId) async {
  //   final ApiResponse response = await _apiCommunication
  //       .doPostRequest(apiEndPoint: 'delete-page', requestData: {
  //     '_id': pageId,
  //   });
  //   if (response.isSuccessful) {
  //     pageProfileModel;

  //     Get.back();
  //     Get.back();
  //     Get.back();
  //     showSuccessSnackkbar(message: 'Page deleted successfully');
  //   } else {
  //     debugPrint('');
  //   }
  // }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    pageNameController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    whatsAppNumberController = TextEditingController();
    phoneNumberController = TextEditingController();
    // String pageUserName = Get.arguments();

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();

    super.onClose();
  }
}
