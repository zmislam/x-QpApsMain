import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../models/api_response.dart';
import '../../../../../../../../models/profile_model.dart';
import '../../../../../../../../models/social_media_model.dart';
import '../../../../../../../../models/websites.dart';
import '../../../../../../../../services/api_communication.dart';



class AboutController extends GetxController {
 late final ApiCommunication _apiCommunication;
 late final LoginCredential loginCredential;
 Rx<ProfileModel?> profileModel = Rx(null);
 RxBool isLoading = true.obs;
  RxList<SocialMediaModel> socialMediaList = <SocialMediaModel>[].obs;




Websites websites = Websites();


/* =================================================================Get User Data================================================*/
 Future getUserALLData() async {
   isLoading.value = true;
   ApiResponse apiResponse = await _apiCommunication.doPostRequest(
     apiEndPoint: 'get-user-info',
     requestData: {'username': '${loginCredential.getUserData().username}'},
     responseDataKey: 'userInfo',
     // enableLoading: true,
   );
   isLoading.value = false;
   debugPrint('Loading About: ===== ${isLoading.value.toString()}==========');


   if (apiResponse.isSuccessful) {
     profileModel.value =
         ProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);


     debugPrint(profileModel.value.toString());
   }
 }
/* =================================================================Delete WorkPlace===============================================*/


 Future<void> onTapDeleteWorkPlacePost(String workPlaceId) async {
   final workplace = profileModel.value?.userWorkplaces?.firstWhere(
     (workplace) => workplace.id == workPlaceId,
   );
   if(workplace != null) {
     final ApiResponse response = await _apiCommunication.doPostRequest(
     apiEndPoint: 'delete-workplace',
     isFormData: false,
     enableLoading: true,
     requestData: {
       '_id': workplace.id,
     },
   );
   if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('');
   }
   }
   else{
     debugPrint('WorkPlace ID Not Found');
   }
 }
/* =================================================================Delete Website===============================================*/


Future<void> onTapDeleteWebsitePost(String socialMediaId) async {
 final website = profileModel.value?.websites?.firstWhere(
   (website) => website.id == socialMediaId,
 
 );


  if (website != null) {
   final ApiResponse response = await _apiCommunication.doDeleteRequest(
     apiEndPoint: 'delete-user-website/${website.id}',
     isFormData: false,
     enableLoading: true,
     requestData: {
    
     },
   );


   if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('Failed to delete the social media entry.');
   }
 } else {
   debugPrint('Social media ID not found in websites.');
 }
}






/* =================================================================Delete Phone Number==============================================*/


 Future<void> onTapDeletePhonePost(String phoneId) async {
   final phone = profileModel.value?.phone_list?.firstWhere(
   (phone) => phone.id == phoneId,
 
 );
 if(phone !=null){
   final ApiResponse response = await _apiCommunication.doPostRequest(
     apiEndPoint: 'settings-privacy/delete-phone-email-language',
     isFormData: false,
     enableLoading: true,
     requestData: {'phone_id': phone.id},
   );
    if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('');
   }
 }
 else{
   debugPrint('Phone ID not found in phone list.');
 }
 }
  


   /* =================================================================Delete Language==============================================*/


 Future<void> onTapDeleteLanguagePost(String langId) async {
   final language = profileModel.value?.language?.firstWhere(
   (language) => language.id == langId,
 
 );
 if(language !=null){
   final ApiResponse response = await _apiCommunication.doPostRequest(
     apiEndPoint: 'settings-privacy/delete-phone-email-language',
     isFormData: false,
     enableLoading: true,
     requestData: {'language_id': language.id},
   );
    if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('');
   }
 }
 else{
   debugPrint('Language ID not found in phone list.');
 }
 }
/* =================================================================Delete Email ===============================================*/
 


 Future<void> onTapDeleteEmailPost(String emailId) async {
   final email = profileModel.value?.email_list?.firstWhere(
   (email) => email.id == emailId,
 
 );
 if(email !=null){
   final ApiResponse response = await _apiCommunication.doPostRequest(
     apiEndPoint: 'settings-privacy/delete-phone-email-language',
     isFormData: false,
     enableLoading: true,
     requestData: {'email_id': email.id},
   );
    if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('');
   }
 }
 else{
   debugPrint('Email ID not found in phone list.');
 }
 }
/* =================================================================Delete Educational Workplace===============================================*/




 Future<void> onTapDeleteInstitutePost(String instituteId) async {
  final institute = profileModel.value?.educationWorkplaces?.firstWhere(
   (institute) => institute.id == instituteId,
 
 );
 if(institute != null){
   final ApiResponse response = await _apiCommunication.doPostRequest(
     apiEndPoint:
         'delete-education/${institute.id}',
     isFormData: false,
     enableLoading: true,
     requestData: {},
   );
   if (response.isSuccessful) {
     getUserALLData();
     // Get.back();
   } else {
     debugPrint('');
   }
 }
 else{
   debugPrint('Institute ID not found in institute list.');
 }
 }
  


 @override
 void onInit() {
   _apiCommunication = ApiCommunication();
   loginCredential = LoginCredential();
  
   // getUserALLData();
   super.onInit();
 }


 @override
 void onClose() {
   _apiCommunication.endConnection();
   super.onClose();
 }
}



