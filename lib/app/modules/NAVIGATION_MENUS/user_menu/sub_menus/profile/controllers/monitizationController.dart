import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import 'dart:io';
import '../../../../../../models/api_response.dart';
import '../../../../../../services/api_communication.dart';
import '../models/earningDashboard.dart';
import 'package:dio/dio.dart';

class MonetizationController extends GetxController {
  // Form Controllers
  final verificationDocumentNumberController = TextEditingController();

  // Dropdown values
  final RxString selectedVerificationDocument =
      'Select Verification Document'.obs;
  final RxString selectedResidentialVerification =
      'Select Residential Verification'.obs;

  // File uploads
  final RxList<File> verificationDocumentFile = <File>[].obs;
  final Rxn<File> residentialDocumentFile = Rxn<File>();

  // Errors for UI
  final RxString verificationDocumentError = ''.obs;
  final RxString documentNumberError = ''.obs;
  final RxString residentialVerificationError = ''.obs;
  final RxString verificationFileError = ''.obs;
  final RxString residentialFileError = ''.obs;

  // Optional: per-index error fields (useful to show 'front/back required')
  final RxString verificationFrontFileError = ''.obs;
  final RxString verificationBackFileError = ''.obs;

  // Dropdown options
  final List<String> verificationDocuments = [
    'Select Verification Document',
    'Passport',
    'National ID Card',
    'Driving License',
  ];

  final List<String> residentialVerifications = [
    'Select Residential Verification',
    'Bank Statement',
    'Utility Bill',
    'Resident Permit',
  ];

  final Map<String, String> verificationTypeMap = {
    'Passport': 'passport',
    'National ID Card': 'id_card',
    'Driving License': 'driving_lic',
  };

  final Map<String, String> residentialTypeMap = {
    'Bank Statement': 'bank_statement',
    'Utility Bill': 'utility_bill',
    'Resident Permit': 'resident_permit',
  };

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  /// Pick verification document.
  /// - `index`: 0 => front (or only file), 1 => back (for National ID)
  /// For National ID Card: force camera (no gallery).
  /// For others: open gallery.
  Future<void> pickVerificationDocument({required int index}) async {
    final lower = selectedVerificationDocument.value.toLowerCase();
    final isMultiPageDoc = lower.contains('national id') || lower.contains('driving license') || lower.contains('passport');

    XFile? picked;
    try {
      if (isMultiPageDoc) {
        // Force camera for National ID / Driving License (front/back)
        picked = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1600,
          maxHeight: 1200,
          imageQuality: 85,
        );
      } else {
        // For other documents, allow gallery selection
        picked = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1200,
          imageQuality: 85,
        );
      }

      if (picked == null) return;

      final file = File(picked.path);

      // Ensure list size and assign at index
      if (verificationDocumentFile.length <= index) {
        // Expand list up to index by repeating a placeholder file (keeps behavior similar to previous code)
        // We'll push the new file to fill missing slots, then overwrite target index if needed.
        while (verificationDocumentFile.length <= index) {
          verificationDocumentFile.add(file);
        }
        verificationDocumentFile[index] = file;
      } else {
        verificationDocumentFile[index] = file;
      }

      // Clear related errors
      verificationFileError.value = '';
      verificationFrontFileError.value = '';
      verificationBackFileError.value = '';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick residential document (still gallery)
  Future<void> pickResidentialDocument() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        residentialDocumentFile.value = File(image.path);
        residentialFileError.value = '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick residential document: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ---- VALIDATION ----
  bool validateForm() {
    bool isValid = true;

    // Verify dropdowns
    if (selectedVerificationDocument.value == 'Select Verification Document') {
      verificationDocumentError.value = 'Document is Required';
      isValid = false;
    } else {
      verificationDocumentError.value = '';
    }

    if (verificationDocumentNumberController.text.trim().isEmpty) {
      documentNumberError.value = 'Document Number is Required';
      isValid = false;
    } else {
      documentNumberError.value = '';
    }

    if (selectedResidentialVerification.value ==
        'Select Residential Verification') {
      residentialVerificationError.value =
      'Residential Verification is Required';
      isValid = false;
    } else {
      residentialVerificationError.value = '';
    }

    // Validate verification document file based on type
    final String? verificationTypeKey =
    verificationTypeMap[selectedVerificationDocument.value];

    if (verificationTypeKey == 'id_card') {
      // National ID requires both front and back
      if (verificationDocumentFile.isEmpty) {
        verificationFrontFileError.value = 'Front side is Required';
        isValid = false;
      } else {
        verificationFrontFileError.value = '';
      }

      if (verificationDocumentFile.length < 2) {
        verificationBackFileError.value = 'Back side is Required';
        isValid = false;
      } else {
        verificationBackFileError.value = '';
      }
    } else {
      // Passport or Driving License requires only one file
      if (verificationDocumentFile.isEmpty) {
        verificationFileError.value = 'Verification Document is Required';
        isValid = false;
      } else {
        verificationFileError.value = '';
      }
    }

    // Residential file
    if (residentialDocumentFile.value == null) {
      residentialFileError.value = 'Residential Document is Required';
      isValid = false;
    } else {
      residentialFileError.value = '';
    }

    return isValid;
  }

  // ---- SUBMIT ----
  Future<void> applyForMonetization() async {
    if (!validateForm()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final String? verificationTypeKey =
      verificationTypeMap[selectedVerificationDocument.value];
      final String? residentialTypeKey =
      residentialTypeMap[selectedResidentialVerification.value];

      // Prepare request data (text fields only)
      Map<String, dynamic> requestData = {
        'verification_details': verificationDocumentNumberController.text.trim(),
        'verification_type': verificationTypeKey ?? '',
        'residential_type': residentialTypeKey ?? '',
      };

      // Prepare file map with verification files and residential file
      List<File> allFiles = [];
      allFiles.addAll(verificationDocumentFile);
      if (residentialDocumentFile.value != null) {
        allFiles.add(residentialDocumentFile.value!);
      }

      final ApiResponse response = await ApiCommunication().doPostRequest(
        apiEndPoint: 'turn-on-earning-dashboard',
        requestData: requestData,
        mediaFiles: verificationDocumentFile,
        fileKey: 'verification_file',
        fileMap: residentialDocumentFile.value != null
            ? {'residential_file': residentialDocumentFile.value!}
            : null,
        isFormData: true,
        enableLoading: true,
      );

      if (response.isSuccessful) {
        final TurnOnEarningDashboard result = TurnOnEarningDashboard.fromJson(
          (response.data is Map<String, dynamic>)
              ? response.data as Map<String, dynamic>
              : {},
        );
        Get.back();
        Get.snackbar(
          'Success',
          result.message ?? 'Monetization application submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        resetForm();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to submit application',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> disableMonetization() async {
    try {
      ApiResponse response = await ApiCommunication().doPostFormRequest(
        apiEndPoint: 'turn-off-earning-dashboard',
        enableLoading: true,
      );

      if (response.isSuccessful) {
        final TurnOnEarningDashboard result = TurnOnEarningDashboard.fromJson(
          (response.data is Map<String, dynamic>)
              ? response.data as Map<String, dynamic>
              : {},
        );
        await Get.find<ProfileController>().getUserData();
        Get.snackbar(
          'Success',
          result.message ?? 'Monetization turned off successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        resetForm();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to turn off monetization',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Reset form
  void resetForm() {
    selectedVerificationDocument.value = 'Select Verification Document';
    selectedResidentialVerification.value = 'Select Residential Verification';
    verificationDocumentNumberController.clear();
    verificationDocumentFile.clear();
    residentialDocumentFile.value = null;
    verificationDocumentError.value = '';
    documentNumberError.value = '';
    residentialVerificationError.value = '';
    verificationFileError.value = '';
    residentialFileError.value = '';
    verificationFrontFileError.value = '';
    verificationBackFileError.value = '';
  }

  @override
  void onClose() {
    verificationDocumentNumberController.dispose();
    super.onClose();
  }
}
