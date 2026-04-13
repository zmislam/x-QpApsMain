import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../../NAVIGATION_MENUS/buyer_panel/buyer_dashboard/models/buyer_complaint_model.dart';

class BuyerComplaintsController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  // List state
  RxList<BuyerComplaintModel> complaints = <BuyerComplaintModel>[].obs;
  RxBool isLoading = true.obs;
  RxString searchQuery = ''.obs;

  // Detail state
  Rx<BuyerComplaintModel?> selectedComplaint =
      Rx<BuyerComplaintModel?>(null);
  RxBool isLoadingDetail = false.obs;

  // Submit form state
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final detailsController = TextEditingController();
  RxString selectedIssueType = ''.obs;
  RxList<String> issueTypes = <String>[].obs;
  RxList<XFile> selectedMedia = <XFile>[].obs;
  RxBool isSubmitting = false.obs;

  List<BuyerComplaintModel> get filteredComplaints {
    if (searchQuery.value.isEmpty) return complaints;
    final q = searchQuery.value.toLowerCase();
    return complaints.where((c) {
      final type = c.issueType?.toLowerCase() ?? '';
      final details = c.details?.toLowerCase() ?? '';
      final status = c.status?.toLowerCase() ?? '';
      return type.contains(q) || details.contains(q) || status.contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
    fetchIssueTypes();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    detailsController.dispose();
    super.onClose();
  }

  Future<void> fetchComplaints() async {
    isLoading.value = true;
    final response = await _repo.getComplaintList();
    if (response.isSuccessful && response.data is List) {
      complaints.value = (response.data as List)
          .map((e) =>
              BuyerComplaintModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      complaints.clear();
    }
    isLoading.value = false;
  }

  Future<void> fetchComplaintDetails(String complaintId) async {
    isLoadingDetail.value = true;
    final response =
        await _repo.getComplaintDetails(complaintId: complaintId);
    if (response.isSuccessful && response.data is Map<String, dynamic>) {
      selectedComplaint.value =
          BuyerComplaintModel.fromMap(response.data as Map<String, dynamic>);
    }
    isLoadingDetail.value = false;
  }

  Future<void> fetchIssueTypes() async {
    final response = await _repo.getComplaintTypeList();
    if (response.isSuccessful && response.data is List) {
      issueTypes.value = (response.data as List)
          .map((e) => e.toString())
          .toList();
    }
  }

  Future<void> submitComplaint({
    required String storeId,
    required List<String> productIds,
    String? orderId,
  }) async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        selectedIssueType.value.isEmpty ||
        detailsController.text.trim().isEmpty) {
      showErrorSnackkbar(message: 'Please fill in all required fields');
      return;
    }

    isSubmitting.value = true;
    final response = await _repo.saveComplaint(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      storeId: storeId,
      productIds: productIds,
      orderId: orderId,
      issueType: selectedIssueType.value,
      details: detailsController.text.trim(),
      mediaFiles: selectedMedia.isNotEmpty ? selectedMedia.toList() : null,
    );
    isSubmitting.value = false;

    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Complaint submitted successfully');
      _clearForm();
      Get.back();
      await fetchComplaints();
    } else {
      showErrorSnackkbar(
          message: response.message ?? 'Failed to submit complaint');
    }
  }

  Future<void> deleteComplaint(String complaintId) async {
    final response =
        await _repo.deleteComplaint(complaintId: complaintId);
    if (response.isSuccessful) {
      complaints.removeWhere((c) => c.id == complaintId);
      showSuccessSnackkbar(message: 'Complaint deleted');
    } else {
      showErrorSnackkbar(message: 'Failed to delete complaint');
    }
  }

  void pickMedia() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      selectedMedia.addAll(files);
    }
  }

  void removeMedia(int index) {
    selectedMedia.removeAt(index);
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    detailsController.clear();
    selectedIssueType.value = '';
    selectedMedia.clear();
  }
}
