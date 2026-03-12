import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/login_creadential.dart';
import '../../../models/user.dart';
import '../../../services/api_communication.dart';

class SharePostController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late UserModel userModel;
  late TextEditingController descriptionController;
  static const List<String> list = [
    'public',
    'friends',
    'only me',
  ];

  RxString dropdownValue = list.first.obs;
  RxString postPrivacy = 'public'.obs;

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    descriptionController = TextEditingController();
    descriptionController.clear();
    userModel = _loginCredential.getUserData();
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();

    descriptionController.clear();
    userModel = _loginCredential.getUserData();
    super.onClose();
  }
}
