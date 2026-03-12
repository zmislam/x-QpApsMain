import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../../group_profile/controllers/group_profile_controller.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';

class GroupFileUploadController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  final GroupProfileController _groupProfileController =Get.find();
  final GlobalKey<FormState> formKey = GlobalKey();
  RxString coverPhotoError = ''.obs;
  RxBool isSaveButtonEnabled = false.obs;
  Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);


  Rx<List<File>> files = Rx([]);


  late TextEditingController descriptionController;


  //-------------------------------------- PICK FILES ----------------------------//
Future<void> pickFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
       type: FileType.custom, 
allowedExtensions :[
    'pdf',  // PDF files
    'doc',  // Word documents
    'docx', // Word documents
    'xls',  // Excel spreadsheets
    'xlsx', // Excel spreadsheets
    'ppt',  // PowerPoint presentations
    'pptx', // PowerPoint presentations
    'txt',  // Text files
    'csv',  // CSV files
    'xml',  // XML files
    'json', // JSON files
    // Add more document types as needed
  ]
   
  );

  if (result != null) {
    List<File> pickedFiles = result.files.reversed.map((platformFile) {
     
      if (platformFile.path != null) {
        return File(platformFile.path!);
      } else {
    
        throw Exception('File path is null');
      }
    }).toList();

    files.value.addAll(pickedFiles);
    files.refresh();
  }
}

//-------------------------------------- Upload Files ----------------------------//
  Future<void> uploadFiles() async {
    // selectedUsernames.value = friendList.value.map((item) => item.userId?.username ?? '').toList();

    final ApiResponse response = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'save-group-post',
      isFormData: true,
      enableLoading: true,
      fileKeys: ['files'],
      requestData: {
        'group_id':allGroupModel.value?.id,
        'description': descriptionController.text,
        'post_type': 'group_file',
      },
      mediaFiles: files.value,
    );

    if (response.isSuccessful) {
      _groupProfileController.fetchGroupFiles();
      _groupProfileController.getGroupPosts();
      Get.back();
      showSuccessSnackkbar(message: 'File Uploaded successfully');
    } else {
      debugPrint('Failed to Upload File: ${response.message}');

    }
  }

  
  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    allGroupModel =Get.arguments;
    descriptionController = TextEditingController();
    super.onInit();
  }
}
