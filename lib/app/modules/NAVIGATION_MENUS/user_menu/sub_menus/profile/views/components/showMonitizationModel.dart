import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../../../../utils/customDropDown.dart';
import '../../controllers/monitizationController.dart';


void showMonetizationModal(BuildContext context) {
  // Get existing controller or create new one
  final controller = Get.isRegistered<MonetizationController>()
      ? Get.find<MonetizationController>()
      : Get.put(MonetizationController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monetization Apply'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 28),
                      onPressed: () {
                        controller.resetForm();
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Verification Document Dropdown
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CustomDropdown(
                      title: 'Verification Document'.tr,
                      selectedValue:
                      controller.selectedVerificationDocument.value,
                      items: controller.verificationDocuments,
                      errorText:
                      controller.verificationDocumentError.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedVerificationDocument.value =
                              newValue;
                          controller.verificationDocumentError.value =
                          '';
                        }
                      },
                    )),
                    if (controller.verificationDocumentError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          controller.verificationDocumentError.value,
                          style:
                          TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: 20),

                // Verification Document Number TextField
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Verification Document Number '.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '*'.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller:
                      controller.verificationDocumentNumberController,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        hintText:
                        'Enter Verification Document Number'.tr,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: controller.documentNumberError.value
                                .isNotEmpty
                                ? Colors.red
                                : Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: controller.documentNumberError.value
                                .isNotEmpty
                                ? Colors.red
                                : Color(0xFF0D7377),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          controller.documentNumberError.value = '';
                        }
                      },
                    ),
                    if (controller.documentNumberError.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          controller.documentNumberError.value,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: 20),

                // Residential Verification Dropdown
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CustomDropdown(
                      title: 'Residential Verification'.tr,
                      selectedValue:
                      controller.selectedResidentialVerification.value,
                      items: controller.residentialVerifications,
                      errorText:
                      controller.residentialVerificationError.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedResidentialVerification.value =
                              newValue;
                          controller.residentialVerificationError.value =
                          '';
                        }
                      },
                    )),
                    if (controller.residentialVerificationError.value
                        .isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          controller.residentialVerificationError.value,
                          style:
                          TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: 20),

                Obx(() {
                  final selected = controller.selectedVerificationDocument.value ?? '';
                  final files = controller.verificationDocumentFile;

                  // Check if National ID or Driving License is selected
                  if (selected.toLowerCase().contains('national id') ||
                      selected.toLowerCase().contains('driving license')) {
                    final File? front = files.isNotEmpty ? files[0] : null;
                    final File? back = files.length > 1 ? files[1] : null;

                    // Determine the title prefix based on selection
                    final String documentType = selected.toLowerCase().contains('national id')
                        ? 'National ID Card'
                        : 'Driving License';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUploadSection(
                          title: '$documentType - Front'.tr,
                          file: front,
                          errorMessage: controller.verificationFrontFileError.value,
                          onPressed: () => controller.pickVerificationDocument(index: 0),
                        ),
                        SizedBox(height: 16),
                        _buildUploadSection(
                          title: '$documentType - Back'.tr,
                          file: back,
                          errorMessage: controller.verificationBackFileError.value,
                          onPressed: () => controller.pickVerificationDocument(index: 1),
                        ),
                      ],
                    );
                  } else {
                    final File? single = files.isNotEmpty ? files[0] : null;
                    return _buildUploadSection(
                      title: 'Upload Verification Document'.tr,
                      file: single,
                      errorMessage: controller.verificationFileError.value,
                      onPressed: () => controller.pickVerificationDocument(index: 0),
                    );
                  }
                }),

                SizedBox(height: 20),

                // Upload Residential Verification Document
                Obx(() => _buildUploadSection(
                  title: 'Residential Verification Document'.tr,
                  file: controller.residentialDocumentFile.value,
                  errorMessage: controller.residentialFileError.value,
                  onPressed: controller.pickResidentialDocument,
                )),
                SizedBox(height: 32),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.applyForMonetization,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0D7377),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Apply For Monetization'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    },
  ).whenComplete(() => controller.resetForm());
}

Widget _buildUploadSection({
  required String title,
  required File? file,
  required String errorMessage,
  required VoidCallback onPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: '$title ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '*'.tr,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            border: Border.all(
              color: errorMessage.isNotEmpty ? Colors.red : Color(0xFF0D7377),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Show image preview if file is selected
              if (file != null)
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Image.asset('assets/image/id-card.png', height: 40, width: 40,),
              SizedBox(height: 12),
              Text(
                file == null ? 'Capture Image '.tr : 'Image Attached'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              // if (file != null)
              //   Padding(
              //     padding: EdgeInsets.only(top: 8),
              //     child: Text(
              //       file.path.split('/').last,
              //       style: TextStyle(
              //         fontSize: 12,
              //         color: Colors.grey[600],
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF0D7377)),
                  foregroundColor: Color(0xFF0D7377),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  file == null ? 'Attach Image'.tr : 'Change Image'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      if (errorMessage.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(top: 8, left: 12),
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  );
}
