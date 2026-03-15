import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../services/api_communication.dart';
import '../../../config/constants/api_constant.dart';
import '../repository/event_repository.dart';

class CreateEventController extends GetxController {
  final EventRepository _repo = EventRepository();
  final ApiCommunication _api = ApiCommunication();
  final ImagePicker _picker = ImagePicker();

  // ─── Form fields ────────────────────────────────────────────────────
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();
  final cityController = TextEditingController();
  final meetingUrlController = TextEditingController();

  // ─── Cover image ───────────────────────────────────────────────────
  final coverImagePath = ''.obs;        // local file path for preview
  final coverImageServerName = ''.obs;  // server filename after upload
  final isUploadingCover = false.obs;

  // ─── Date & time ───────────────────────────────────────────────────
  final startDate = Rx<DateTime>(DateTime.now().add(const Duration(hours: 1)));
  final endDate = Rx<DateTime?>(null);
  final showEndDate = false.obs;
  final timezone = 'UTC+06'.obs;

  // ─── Repeat ────────────────────────────────────────────────────────
  final isRecurring = false.obs;
  final recurrenceRule = ''.obs;

  // ─── Event mode ────────────────────────────────────────────────────
  final eventMode = 'in_person'.obs;
  final eventModes = const [
    {'key': 'in_person', 'label': 'In person'},
    {'key': 'virtual', 'label': 'Virtual'},
    {'key': 'hybrid', 'label': 'Hybrid'},
  ];

  // ─── Privacy ───────────────────────────────────────────────────────
  final privacy = 'public'.obs;
  final privacyOptions = const [
    {'key': 'public', 'label': 'Public'},
    {'key': 'friends', 'label': 'Friends'},
    {'key': 'private', 'label': 'Only me'},
  ];

  // ─── Flags ─────────────────────────────────────────────────────────
  final isSubmitting = false.obs;

  String get formattedStartDate {
    final dt = startDate.value;
    return DateFormat('EEEE, d MMMM yyyy HH:mm').format(dt);
  }

  bool get isFormValid =>
      titleController.text.trim().isNotEmpty;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    cityController.dispose();
    meetingUrlController.dispose();
    super.onClose();
  }

  // ─── Image picking ──────────────────────────────────────────────────
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        coverImagePath.value = image.path;
        await _uploadCoverImage(image);
      }
    } catch (e) {
      print('pickFromGallery error: $e');
      Get.snackbar('Error', 'Could not open gallery',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        coverImagePath.value = image.path;
        await _uploadCoverImage(image);
      }
    } catch (e) {
      print('pickFromCamera error: $e');
      Get.snackbar('Error', 'Could not open camera',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _uploadCoverImage(XFile image) async {
    isUploadingCover.value = true;
    try {
      final resp = await _api.doPostRequest(
        apiEndPoint: 'image-checker',
        mediaXFiles: [image],
        isFormData: true,
        fileKey: 'file',
        enableLoading: false,
        responseDataKey: ApiConstant.FULL_RESPONSE,
      );
      if (resp.isSuccessful && resp.data != null) {
        final data = resp.data as Map<String, dynamic>;
        final bool isSexual = data['sexual'] == true;
        if (isSexual) {
          coverImagePath.value = '';
          Get.snackbar('Rejected', 'This image violates our content policy',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          coverImageServerName.value = data['data'] ?? '';
        }
      } else {
        Get.snackbar('Error', 'Failed to upload image',
            snackPosition: SnackPosition.BOTTOM);
        coverImagePath.value = '';
      }
    } catch (e) {
      print('_uploadCoverImage error: $e');
      Get.snackbar('Error', 'Image upload failed',
          snackPosition: SnackPosition.BOTTOM);
      coverImagePath.value = '';
    }
    isUploadingCover.value = false;
  }

  void removeCoverImage() {
    coverImagePath.value = '';
    coverImageServerName.value = '';
  }

  // ─── Date pickers ──────────────────────────────────────────────────
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDate.value),
    );
    if (time == null) return;

    startDate.value = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
  }

  Future<void> pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? startDate.value.add(const Duration(hours: 2)),
      firstDate: startDate.value,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        endDate.value ?? startDate.value.add(const Duration(hours: 2)),
      ),
    );
    if (time == null) return;

    endDate.value = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
  }

  void toggleEndDate() {
    showEndDate.value = !showEndDate.value;
    if (!showEndDate.value) {
      endDate.value = null;
    }
  }

  // ─── Submit ────────────────────────────────────────────────────────
  Future<void> createEvent() async {
    if (!isFormValid) {
      Get.snackbar('Error', 'Please enter an event name',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isUploadingCover.value) {
      Get.snackbar('Please wait', 'Cover image is still uploading',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      final data = <String, dynamic>{
        'title': titleController.text.trim(),
        'start_date': startDate.value.toIso8601String(),
        'event_mode': eventMode.value,
        'privacy': privacy.value,
        'timezone': timezone.value,
      };

      // Only add non-empty optional fields
      final desc = descriptionController.text.trim();
      if (desc.isNotEmpty) data['description'] = desc;

      if (coverImageServerName.value.isNotEmpty) {
        data['cover_image'] = coverImageServerName.value;
      }

      if (endDate.value != null) {
        data['end_date'] = endDate.value!.toIso8601String();
      }

      if (isRecurring.value) {
        data['is_recurring'] = true;
        if (recurrenceRule.value.isNotEmpty) {
          data['recurrence_rule'] = recurrenceRule.value;
        }
      }

      final venue = venueController.text.trim();
      if (venue.isNotEmpty) data['venue_name'] = venue;

      final city = cityController.text.trim();
      if (city.isNotEmpty) data['city'] = city;

      final meetingUrl = meetingUrlController.text.trim();
      if (meetingUrl.isNotEmpty) data['meeting_url'] = meetingUrl;

      final resp = await _repo.createEvent(data);
      if (resp.isSuccessful) {
        Get.back(result: true);
        Get.snackbar('Success', 'Event created successfully',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', resp.message ?? 'Failed to create event',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('createEvent error: $e');
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM);
    }
    isSubmitting.value = false;
  }
}
