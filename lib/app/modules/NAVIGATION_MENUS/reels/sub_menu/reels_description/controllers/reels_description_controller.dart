import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/string/string.dart';
import '../../../../../../routes/app_pages.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../models/location_model.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../controllers/reels_controller.dart';
import '../../create_reels/controllers/create_reels_controller.dart';
import '../../create_reels/model/reels_request_data_model.dart';
import '../model/reels_privacy_model.dart';

class ReelsDescriptionController extends GetxController {
  // =================================== Regex ============================================
  RegExp link = RegExp(r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');

  // =================================== variables ========================================
  late final TextEditingController reelDescriptionController;
  late final TextEditingController addLinkController;
  Rx<AllLocation?> locationName = Rx(null);
  Rx<ReelsPrivacyModel?> selectedPrivacy = Rx(null);
  Rx<bool> isAllowComment = true.obs;
  Rx<ReelsRequestDataModel?> reelsDataModel = Rx(null);
  VideoPlayerController? videoPlayerController;

  // =================================== privacy list =====================================
  Rx<List<ReelsPrivacyModel>> privacyList = Rx([ReelsPrivacyModel(icon: Icons.people_outline, privacyStatus: 'Friends'), ReelsPrivacyModel(icon: Icons.public_outlined, privacyStatus: 'Public'), ReelsPrivacyModel(icon: Icons.lock_outline, privacyStatus: 'Only Me')]);
  Rx<String> linkAddress = Rx('');

  // =================================== update privacy status ============================
  void selectedPrivacyStatus(int index) {
    selectedPrivacy.value = privacyList.value[index];
    selectedPrivacy.refresh();
  }

  // =================================== update coumment status ===========================
  void toggleComment() {
    isAllowComment.value = !isAllowComment.value;
  }

  final ReelsRepository _reelsRepository = ReelsRepository();
  RxBool isPublishReelPostCalled = false.obs;
  Future<void> onTapPublihReelsPost() async {
    isPublishReelPostCalled.value = true;
    bool isSuccessful = (reelsDataModel.value?.file?.path ?? '').toLowerCase().endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])
        ? await _reelsRepository.createReels(
            requestData: {
              'description': reelDescriptionController.text,
              'reels_privacy': (selectedPrivacy.value?.privacyStatus ?? '').toLowerCase(),
              'startTime': reelsDataModel.value?.startTime,
              'endTime': reelsDataModel.value?.endTime,
              'user_id': reelsDataModel.value?.user_id,
              'enabled_comment': isAllowComment.value,
              'reels_data': reelsDataModel.value?.reelsDataModel?.toJson(),
              'link': linkAddress,
              'location': locationName.value?.locationName
            },
            video: reelsDataModel.value!.file!,
          )
        : await _reelsRepository.createImageReels(
            requestData: {
              'description': reelDescriptionController.text,
              'reels_privacy': (selectedPrivacy.value?.privacyStatus ?? '').toLowerCase(),
              'startTime': reelsDataModel.value?.startTime,
              'endTime': reelsDataModel.value?.endTime,
              'user_id': reelsDataModel.value?.user_id,
              'enabled_comment': isAllowComment.value,
              'reels_data': reelsDataModel.value?.reelsDataModel?.toJson(),
              'link': linkAddress.value,
              'location': locationName.value?.locationName
            },
            image: reelsDataModel.value!.file!,
          );

    if (isSuccessful) {
      reelsDataModel.value!.file = null;
      isPublishReelPostCalled.value = false;

      ReelsController videoController = Get.find<ReelsController>();

      // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
      // @┃  ADDING THE CreateReelsController FOR MANAGING THE POP UP BLOCKING ON  ┃
      // @┃  REEL CREATION DISCARD SCREEN. THIS WAS CAUSING AN ERROR ON RETURN AS  ┃
      // @┃  WE ENTER 3 SCREENS BUT IN RETURN PATH WE HAVE 4                       ┃
      // $┃  WE SET THE [createReelsController.showPopUp] TO [false] FOR BLOCKING  ┃
      // $┃  THE POPUP                                                             ┃
      // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
      CreateReelsController createReelsController = Get.find<CreateReelsController>();
      createReelsController.showPopUp = false;

      await videoController.reInitRequiredData().then(
        (value) {
          Get.until((route) => route.settings.name == Routes.TAB);
          videoController.update();
        },
      );
    } else {
      showErrorSnackkbar(message: 'Something went wrong');
    }
  }

  void writeLink() {
    if (addLinkController.text.trim().isEmpty) {
      showErrorSnackkbar(message: 'Empty Field');
    } else if (!link.hasMatch(addLinkController.text.trim())) {
      showErrorSnackkbar(message: 'Invalid Link Address');
    } else {
      linkAddress.value = addLinkController.text.trim();
      Get.back();
      addLinkController.clear();
    }
  }

  // =================================== oninit method ====================================
  @override
  void onInit() {
    reelsDataModel.value = Get.arguments as ReelsRequestDataModel;
    if (reelsDataModel.value!.file!.path.toLowerCase().endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
      videoPlayerController = VideoPlayerController.file(File(reelsDataModel.value!.file!.path))
        ..initialize().then((_) {})
        ..setLooping(false);
    }
    reelDescriptionController = TextEditingController();
    addLinkController = TextEditingController();
    selectedPrivacy.value = privacyList.value[1];
    super.onInit();
  }

  // =================================== onClose method ===================================
  @override
  void onClose() {
    reelDescriptionController.dispose();
    reelsDataModel.value!.file = null;
    if (Get.isRegistered<CreateReelsController>() == true) {
      Get.delete<CreateReelsController>(force: true);
      // Get.lazyPut(() => CreateReelsController());
    }

    super.onClose();
  }
}
