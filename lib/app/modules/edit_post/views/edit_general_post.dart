import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../components/image.dart';
import '../../../config/constants/color.dart';
import '../../../data/login_creadential.dart';
import '../../../data/post_color_list.dart';
import '../../../data/post_background.dart';
import '../../../models/media_type_model.dart';
import '../../../models/feeling_model.dart';
import '../../../models/location_model.dart';
import '../../../models/post.dart';
import '../controllers/edit_post_controller.dart';
import 'edit_check_in.dart';
import 'edit_feeling.dart';
import 'edit_tag_people.dart';

// =============================================================================
// EditGeneralPostView — Facebook-inspired design (matches Create Post)
// =============================================================================

class EditGeneralPostView extends GetView<EditPostController> {
  const EditGeneralPostView({super.key, required this.postModel});

  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    updateLocalData();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: surfaceBg,
      // ─── AppBar: < | "Edit Post" centered | Post ───────────────────
      appBar: AppBar(
        backgroundColor: surfaceBg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        toolbarHeight: 50,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Post'.tr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () async {
                await controller.updateUserPost();
              },
              style: TextButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(60, 32),
              ),
              child: Text(
                'Post'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 0.5, color: dividerColor),
        ),
      ),
      // ─── Body ─────────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── User Header + Privacy ─────────────────────
                  _buildUserHeader(context, isDark, textColor, subtitleColor),
                  // ─── Text Input ────────────────────────────────
                  _buildTextInput(context, isDark),
                  // ─── Media Preview ─────────────────────────────
                  _buildMediaPreview(context, isDark),
                ],
              ),
            ),
          ),
          // ─── Color Selector (fixed above toolbar) ──────────────
          _buildColorSelector(context, isDark),
          // ─── Bottom Action Toolbar ─────────────────────────────
          _buildBottomToolbar(context, isDark, textColor, subtitleColor, dividerColor),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  USER HEADER — Avatar + Name + Privacy pills
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildUserHeader(
      BuildContext context, bool isDark, Color textColor, Color subtitleColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCircleAvatar(
            imageUrl: (LoginCredential().getUserData().profile_pic ?? '').formatedProfileUrl,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Name + feeling + location + tags ──────────
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          if (LoginCredential().getUserInfoData().isProfileVerified == true)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.verified, color: PRIMARY_COLOR, size: 15),
                              ),
                            ),
                          // Feeling
                          if (controller.feelingName.value != null) ...[
                            TextSpan(
                              text: ' is feeling'.tr,
                              style: TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${controller.feelingName.value?.feelingName}'.tr,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                            ),
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: _ReactionIcon(controller.feelingName.value!.logo.toString()),
                              ),
                            ),
                          ],
                          // Location
                          if (controller.locationName.value != null) ...[
                            TextSpan(
                              text: ' at'.tr,
                              style: TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${controller.locationName.value?.locationName}'.tr,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                            ),
                          ],
                          // Tagged friends
                          if (controller.checkFriendList.value.length == 1) ...[
                            TextSpan(
                              text: ' with'.tr,
                              style: TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${controller.checkFriendList.value[0].firstName} ${controller.checkFriendList.value[0].lastName}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                            ),
                          ] else if (controller.checkFriendList.value.length > 1) ...[
                            TextSpan(
                              text: ' with'.tr,
                              style: TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' ${controller.checkFriendList.value[0].firstName} ${controller.checkFriendList.value[0].lastName} and ${controller.checkFriendList.value.length - 1} others',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Privacy pill ────────────────────────────────
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildPrivacyPill(isDark),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPill(bool isDark) {
    return Obx(() {
      final value = controller.dropdownValue.value;
      IconData icon;
      switch (value) {
        case 'Friends':
          icon = Icons.people;
          break;
        case 'Only Me':
          icon = Icons.lock;
          break;
        default:
          icon = Icons.public;
      }

      return GestureDetector(
        onTap: () => _showPrivacySheet(Get.context!),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF3A3B3C) : const Color(0xFFE4E6EB),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: isDark ? Colors.white : Colors.black87),
              const SizedBox(width: 5),
              Text(
                value.tr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  PRIVACY BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════════════

  void _showPrivacySheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF262626) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final privacyItems = [
      {'icon': Icons.public, 'label': 'Public'.tr, 'subtitle': 'Anyone on or off the app'.tr, 'value': 'Public'},
      {'icon': Icons.people, 'label': 'Friends'.tr, 'subtitle': 'Your friends on the app'.tr, 'value': 'Friends'},
      {'icon': Icons.lock, 'label': 'Only me'.tr, 'subtitle': 'Only me'.tr, 'value': 'Only Me'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Who can see your post?'.tr,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textColor, size: 22),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Your post will appear in Feed, on your profile and in search results.'.tr,
                    style: TextStyle(fontSize: 13, color: subtitleColor, height: 1.4),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                ...privacyItems.map((item) => Obx(() {
                      final isSelected = controller.dropdownValue.value == item['value'];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                          ),
                          child: Icon(item['icon'] as IconData, color: textColor, size: 20),
                        ),
                        title: Text(item['label'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                        subtitle: Text(item['subtitle'] as String, style: TextStyle(fontSize: 12, color: subtitleColor)),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? PRIMARY_COLOR : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                              width: isSelected ? 7 : 2,
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.dropdownValue.value = item['value'] as String;
                          controller.postPrivacy.value = item['value'] as String;
                          Navigator.of(ctx).pop();
                        },
                      );
                    })),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TEXT INPUT — With background color/gradient support
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTextInput(BuildContext context, bool isDark) {
    return Obx(() {
      // ── Background color / gradient mode ──────────────────────────
      if (controller.isBackgroundColorPost.value) {
        final bg = controller.activeBackground.value;
        final textCol = bg != null
            ? bg.textColor
            : (controller.postBackgroundColor.value.computeLuminance() > 0.45
                ? Colors.black
                : Colors.white);
        final hintCol = bg != null
            ? bg.hintColor
            : textCol.withValues(alpha: 0.5);

        return Container(
          width: double.maxFinite,
          height: 260,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: bg != null && bg.isGradient
              ? bg.toDecoration(borderRadius: BorderRadius.circular(16))
              : BoxDecoration(
                  color: controller.postBackgroundColor.value,
                  borderRadius: BorderRadius.circular(16),
                ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: TextField(
            textAlign: TextAlign.center,
            maxLines: 5,
            controller: controller.descriptionController,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: textCol,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "What's on your mind?".tr,
              hintStyle: TextStyle(fontSize: 20, color: hintCol),
            ),
          ),
        );
      }

      // ── Normal text input ─────────────────────────────────────────
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller.descriptionController,
          maxLines: controller.imageFromNetwork.value.isNotEmpty ? 8 : 12,
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            hintText: "What's on your mind?".tr,
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  MEDIA PREVIEW — Network images + local file images
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildMediaPreview(BuildContext context, bool isDark) {
    return Obx(() {
      if (controller.imageFromNetwork.value.isEmpty) {
        return const SizedBox.shrink();
      }

      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: controller.imageFromNetwork.value.length,
          itemBuilder: (context, index) {
            final media = controller.imageFromNetwork.value[index];
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: media.isFile == true
                          ? FileImage(File(media.imagePath.toString())) as ImageProvider
                          : NetworkImage(media.imagePath.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () {
                      if (media.isFile == true) {
                        controller.imageFromNetwork.value.removeAt(index);
                        controller.xfiles.value.removeAt(index);
                        controller.imageFromNetwork.refresh();
                      } else {
                        controller.removeMediaId.value.add(media.mediaId.toString());
                        controller.imageFromNetwork.value.removeAt(index);
                        controller.imageFromNetwork.refresh();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  COLOR SELECTOR — Inline row + "Choose background" grid sheet
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildColorSelector(BuildContext context, bool isDark) {
    return Obx(() => Visibility(
          visible: controller.imageFromNetwork.value.isEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SizedBox(
              height: 38,
              child: Row(
                children: [
                  // ── Left arrow / back to no-color ───────────────
                  if (controller.isBackgroundColorPost.value)
                    GestureDetector(
                      onTap: () {
                        controller.isBackgroundColorPost.value = false;
                        controller.postBackgroundColor.value = postListColor.first;
                        controller.activeBackground.value = null;
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                          ),
                        ),
                        child: Icon(Icons.chevron_left,
                            size: 20,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      ),
                    ),
                  // ── Color squares ──────────────────────────────
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: postListColor.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            controller.isBackgroundColorPost.value &&
                                controller.activeBackground.value == null &&
                                controller.postBackgroundColor.value == postListColor[index] &&
                                index != 0;
                        final isFirst = index == 0;
                        return GestureDetector(
                          onTap: () {
                            controller.activeBackground.value = null;
                            if (isFirst) {
                              controller.isBackgroundColorPost.value = false;
                            } else {
                              controller.isBackgroundColorPost.value = true;
                              controller.postBackgroundColor.value = postListColor[index];
                            }
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: postListColor[index],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? PRIMARY_COLOR
                                    : (isFirst
                                        ? (isDark ? Colors.grey.shade600 : Colors.grey.shade300)
                                        : Colors.transparent),
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: isFirst
                                ? Center(
                                    child: Text(
                                      'Aa',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  // ── Grid icon — opens "Choose background" sheet ──
                  GestureDetector(
                    onTap: () => _showChooseBackgroundSheet(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(Icons.grid_view_rounded,
                          size: 18,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CHOOSE BACKGROUND SHEET — Decorative gradients
  // ═══════════════════════════════════════════════════════════════════════

  void _showChooseBackgroundSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF262626) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final sectionLabel = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Choose background'.tr,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textColor),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textColor, size: 22),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // ── No background button ──────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: GestureDetector(
                          onTap: () {
                            controller.isBackgroundColorPost.value = false;
                            controller.postBackgroundColor.value = postListColor.first;
                            controller.activeBackground.value = null;
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !controller.isBackgroundColorPost.value
                                    ? PRIMARY_COLOR
                                    : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
                                width: !controller.isBackgroundColorPost.value ? 2.5 : 1,
                              ),
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                            ),
                            child: Center(
                              child: Text(
                                'No background'.tr,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: sectionLabel),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ── Decorative section ────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                        child: Text(
                          'Decorative'.tr,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: sectionLabel),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: postGradientBackgrounds.length,
                        itemBuilder: (context, index) {
                          final bg = postGradientBackgrounds[index];
                          final isSelected = controller.isBackgroundColorPost.value &&
                              controller.activeBackground.value != null &&
                              controller.activeBackground.value!.storageValue == bg.storageValue;

                          return GestureDetector(
                            onTap: () {
                              controller.isBackgroundColorPost.value = true;
                              controller.activeBackground.value = bg;
                              controller.postBackgroundColor.value = bg.primaryColor;
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: bg.gradient,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? PRIMARY_COLOR : Colors.transparent,
                                  width: isSelected ? 3 : 1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BOTTOM TOOLBAR — Horizontal icon row
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBottomToolbar(BuildContext context, bool isDark,
      Color textColor, Color subtitleColor, Color dividerColor) {
    return Obx(() {
      final actions = <Map<String, dynamic>>[
        if (!controller.isBackgroundColorPost.value)
          {
            'icon': Icons.photo_library_rounded,
            'color': const Color(0xFF4CAF50),
            'badge': controller.imageFromNetwork.value.isNotEmpty
                ? '${controller.imageFromNetwork.value.length}'
                : null,
            'onTap': () => controller.pickFiles(),
          },
        {
          'icon': Icons.person_add_alt_1_rounded,
          'color': const Color(0xFF2196F3),
          'badge': null,
          'onTap': () async {
            controller.checkFriendList.value = await Get.to(() => const EditTagPeople());
          },
        },
        {
          'icon': Icons.emoji_emotions_rounded,
          'color': const Color(0xFFFFC107),
          'badge': null,
          'onTap': () async {
            final result = await Get.to(() => const EditFeeling());
            if (result != null && result is PostFeeling) {
              controller.feelingName.value = result;
            }
          },
        },
        {
          'icon': Icons.location_on_rounded,
          'color': const Color(0xFFFF5722),
          'badge': null,
          'onTap': () async {
            final result = await Get.to(() => EditCheckIn());
            if (result != null && result is AllLocation) {
              controller.locationName.value = result;
            }
          },
        },
        {
          'icon': Icons.text_fields_rounded,
          'color': const Color(0xFF607D8B),
          'badge': null,
          'onTap': () {
            if (controller.isBackgroundColorPost.value) {
              controller.isBackgroundColorPost.value = false;
              controller.postBackgroundColor.value = postListColor.first;
              controller.activeBackground.value = null;
            } else if (controller.imageFromNetwork.value.isEmpty) {
              controller.isBackgroundColorPost.value = true;
              controller.postBackgroundColor.value = postListColor[1];
            }
          },
        },
      ];

      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actions.map((action) {
                    return GestureDetector(
                      onTap: action['onTap'] as VoidCallback,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(action['icon'] as IconData, size: 26, color: action['color'] as Color),
                            if (action['badge'] != null)
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    action['badge'] as String,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DATA INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════

  void updateLocalData() {
    controller.descriptionController.clear();
    controller.imageFromNetwork.value.clear();
    controller.removeMediaId.value.clear();

    controller.descriptionController.text = postModel?.description.toString() ?? '';
    controller.userId.value = postModel?.user_id?.id.toString() ?? '';
    controller.postId.value = postModel?.id.toString() ?? '';

    if (postModel?.post_privacy == 'only_me') {
      controller.dropdownValue.value = 'Only Me';
      controller.postPrivacy.value = 'Only Me';
    } else if (postModel?.post_privacy == 'public') {
      controller.dropdownValue.value = 'Public';
      controller.postPrivacy.value = 'Public';
    } else {
      controller.dropdownValue.value = 'Friends';
      controller.postPrivacy.value = 'Friends';
    }

    if (postModel?.post_background_color != '' && postModel?.post_background_color != null) {
      final parsed = PostBackground.parse(postModel!.post_background_color);
      if (parsed != null && parsed.isGradient) {
        controller.activeBackground.value = parsed;
      }
      controller.postBackgroundColor.value = parsed?.primaryColor ?? Color(int.parse('0xff${postModel!.post_background_color}'));
      controller.isBackgroundColorPost.value = true;
    }

    if (postModel?.media != null && postModel!.media!.isNotEmpty) {
      for (int index = 0; index < postModel!.media!.length; index++) {
        controller.imageFromNetwork.value.add(MediaTypeModel(
          imagePath: (postModel!.media![index].media.toString()).formatedPostUrl,
          isFile: false,
          mediaId: postModel!.media![index].id.toString(),
        ));
      }
    }

    if (postModel?.locationName != null) {
      controller.locationName.value = AllLocation(locationName: postModel!.locationName);
      controller.locationId.value = postModel?.location_id?.id.toString() ?? '';
    }

    if (postModel?.feeling_id != null) {
      controller.feelingName.value = PostFeeling(
        id: postModel?.feeling_id?.id.toString() ?? '',
        feelingName: postModel?.feeling_id?.feelingName.toString() ?? '',
        logo: postModel?.feeling_id?.logo.toString() ?? '',
      );
      controller.feelingId.value = postModel?.feeling_id?.id.toString() ?? '';
    }

    if (postModel?.taggedUserList != null && postModel!.taggedUserList!.isNotEmpty) {
      for (int index = 0; index < postModel!.taggedUserList!.length; index++) {
        controller.checkFriendList.value.add(postModel!.taggedUserList![index].user as User);
      }
    }
  }

  Widget _ReactionIcon(String reactionPath) {
    return Image(
      height: 16,
      image: NetworkImage((reactionPath).formatedFeelingUrl),
    );
  }
}
