import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../extension/string/string.dart';
import '../../../../../extension/string/string_image_path.dart';
import 'package:video_player/video_player.dart';
import '../../../../../components/image.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../data/post_background.dart';
import '../../../../../data/post_color_list.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../extension/num.dart';
import '../../../../../models/feeling_model.dart';
import '../../../../../models/location_model.dart';
import '../../../../../routes/app_pages.dart';
import '../components/media/media_component.dart';
import '../components/media_layout_component.dart';
import '../controller/create_post_controller.dart';
import '../models/link_preview_model.dart';

// =============================================================================
// CreatePostView — Facebook-inspired design
// =============================================================================
// Clean, modern Create Post page matching Facebook mobile design:
//  - X (close) | "Create post" centered | Post button (branded)
//  - Avatar + Name + Privacy pills row
//  - Clean text input area
//  - Collapsible action toolbar at bottom with colorful icons
// =============================================================================

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: surfaceBg,
      // ─── AppBar: X | "Create post" | Post ───────────────────────────
      appBar: AppBar(
        backgroundColor: surfaceBg,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        toolbarHeight: 50,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.close, size: 26, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create post'.tr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton(
                  onPressed: controller.isCreatePostCalled.value
                      ? null
                      : () async {
                          await controller.onTapCreatePost();
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: controller.isCreatePostCalled.value
                        ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                        : PRIMARY_COLOR,
                    foregroundColor: controller.isCreatePostCalled.value
                        ? Colors.grey
                        : Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              )),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 0.5, color: dividerColor),
        ),
      ),
      // ─── Body ─────────────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── User Header + Privacy ─────────────────────────
                  _buildUserHeader(context, isDark, textColor, subtitleColor),
                  // ─── Text Input ────────────────────────────────────
                  _buildTextInput(context, isDark),
                  // ─── Link Preview ──────────────────────────────────
                  _buildLinkPreview(context, isDark, dividerColor),
                  // ─── Media Preview ─────────────────────────────────
                  _buildMediaPreview(context, isDark),
                  // ─── Media Layout Chooser ──────────────────────────
                  Obx(() => Visibility(
                        visible: controller.xfiles.value.length > 1,
                        child: MediaLayoutComponent(
                            createPostController: controller),
                      )),
                ],
              ),
            ),
          ),
          // ─── Color Selector (fixed above toolbar) ──────────────────
          _buildColorSelector(context, isDark),
          // ─── Bottom Action Toolbar ─────────────────────────────────
          _buildBottomToolbar(
              context, isDark, textColor, subtitleColor, dividerColor),
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
          // ── Avatar ──────────────────────────────────────────────────
          NetworkCircleAvatar(
            imageUrl: (LoginCredential().getUserData().profile_pic ?? '')
                .formatedProfileUrl,
          ),
          const SizedBox(width: 10),
          // ── Name + metadata + privacy pills ─────────────────────────
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Name + feeling + location + tags ──────────────
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          if (LoginCredential()
                                  .getUserInfoData()
                                  .isProfileVerified ==
                              true)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.verified,
                                    color: PRIMARY_COLOR, size: 15),
                              ),
                            ),
                          // Feeling
                          if (controller.feelingName.value != null) ...[
                            TextSpan(
                              text: ' is feeling'.tr,
                              style:
                                  TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  ' ${controller.feelingName.value?.feelingName}'
                                      .tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: _ReactionIcon(controller
                                    .feelingName.value!.logo
                                    .toString()),
                              ),
                            ),
                          ],
                          // Location
                          if (controller.locationName.value != null) ...[
                            TextSpan(
                              text: ' at'.tr,
                              style:
                                  TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  ' ${controller.locationName.value?.locationName}'
                                      .tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                          ],
                          // Tagged friends
                          if (controller.checkFriendList.value.length ==
                              1) ...[
                            TextSpan(
                              text: ' with'.tr,
                              style:
                                  TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  ' ${controller.checkFriendList.value[0].friend?.firstName ?? ''} ${controller.checkFriendList.value[0].friend?.lastName ?? ''}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                          ] else if (controller.checkFriendList.value.length >
                              1) ...[
                            TextSpan(
                              text: ' with'.tr,
                              style:
                                  TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            TextSpan(
                              text:
                                  ' ${controller.checkFriendList.value[0].friend?.firstName ?? ''} ${controller.checkFriendList.value[0].friend?.lastName ?? ''} and ${controller.checkFriendList.value.length - 1} others',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Privacy pills row ─────────────────────────────
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _PrivacyPill(
                          icon: _privacyIcon(controller.dropdownValue.value),
                          label: controller.dropdownValue.value.tr,
                          onTap: () => _showPrivacySheet(context),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  IconData _privacyIcon(String value) {
    switch (value) {
      case 'Friends':
        return Icons.people;
      case 'Only Me':
        return Icons.lock;
      default:
        return Icons.public;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  PRIVACY BOTTOM SHEET — Facebook-style "Who can see your post?"
  // ═══════════════════════════════════════════════════════════════════════

  void _showPrivacySheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF262626) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final privacyItems = [
      _PrivacyOptionData(
        icon: Icons.public,
        label: 'Public'.tr,
        subtitle: 'Anyone on or off the app'.tr,
        value: 'Public',
      ),
      _PrivacyOptionData(
        icon: Icons.people,
        label: 'Friends'.tr,
        subtitle: 'Your friends on the app'.tr,
        value: 'Friends',
      ),
      _PrivacyOptionData(
        icon: Icons.lock,
        label: 'Only me'.tr,
        subtitle: 'Only me'.tr,
        value: 'Only Me',
      ),
    ];

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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Handle ─────────────────────────────────────────
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ── Header ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Who can see your post?'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
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
                    'Your post will appear in Feed, on your profile and in search results.'
                        .tr,
                    style: TextStyle(
                        fontSize: 13, color: subtitleColor, height: 1.4),
                  ),
                ),
                Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade200),
                // ── Options ────────────────────────────────────────
                ...privacyItems.map((item) => Obx(() {
                      final isSelected =
                          controller.dropdownValue.value == item.value;
                      return InkWell(
                        onTap: () {
                          controller.dropdownValue.value = item.value;
                          Navigator.of(ctx).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(item.icon,
                                    size: 20, color: textColor),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: subtitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? PRIMARY_COLOR
                                        : Colors.grey.shade400,
                                    width: isSelected ? 6 : 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
                const SizedBox(height: 8),
                // ── Done button ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Done'.tr,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
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
  //  TEXT INPUT — Normal or Background Color mode
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTextInput(BuildContext context, bool isDark) {
    return Obx(() {
      if (controller.isBackgroundColorPost.value) {
        // Determine text/hint colors and decoration
        final bg = controller.activeBackground.value;
        final textClr = bg != null
            ? bg.textColor
            : (controller.postBackgroundColor.value.computeLuminance() > 0.45
                ? Colors.black
                : Colors.white);
        final hintClr = bg != null
            ? bg.hintColor
            : Colors.white.withValues(alpha: 0.8);

        final decoration = bg != null && bg.isGradient
            ? bg.toDecoration(borderRadius: BorderRadius.circular(16))
            : BoxDecoration(
                color: controller.postBackgroundColor.value,
                borderRadius: BorderRadius.circular(16),
              );

        // ── Background Color/Gradient Post ────────────────────────────
        return Container(
          width: double.maxFinite,
          height: 260,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: decoration,
          child: TextFormField(
            validator: (text) {
              if (text!.length >= 101) return 'You have crossed word limit';
              return null;
            },
            inputFormatters: [LengthLimitingTextInputFormatter(101)],
            textAlign: TextAlign.center,
            maxLines: 5,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: textClr,
            ),
            controller: controller.descriptionController,
            onChanged: (val) => controller.wordLimit.value = val.toString(),
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              errorText: controller.wordLimit.value.length >= 101
                  ? 'You have crossed word limit'
                  : null,
              hintText:
                  "What's on your mind?".tr,
              hintStyle: TextStyle(
                color: hintClr,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        );
      }

      // ── Normal text input ───────────────────────────────────────────
      return Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              onChanged: (value) {
                final linkRegex = RegExp(
                    r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
                final match = linkRegex.firstMatch(value);
                if (match != null) {
                  controller.getLinkPreview(match.group(0)!);
                } else {
                  controller.clearPreview();
                }
              },
              controller: controller.descriptionController,
              maxLines: controller.xfiles.value.isNotEmpty ? 8 : 12,
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
                hintText:
                    "What's on your mind?".tr,
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color:
                      isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ));
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  LINK PREVIEW
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildLinkPreview(
      BuildContext context, bool isDark, Color dividerColor) {
    return Obx(() {
      if (controller.linkPreview.value == null ||
          controller.xfiles.value.isNotEmpty) {
        return const SizedBox.shrink();
      }
      final preview = controller.linkPreview.value ?? LinkPreview();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (preview.thumbnail != null)
              Stack(
                children: [
                  Image.network(
                    preview.thumbnail ?? '',
                    height: 140,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      height: 140,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => controller.clearPreview(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (preview.title != null)
                    Text(
                      preview.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  if (preview.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      preview.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  COLOR SELECTOR — Inline row + "Choose background" grid sheet
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildColorSelector(BuildContext context, bool isDark) {
    return Obx(() => Visibility(
          visible: controller.xfiles.value.isEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SizedBox(
              height: 38,
              child: Row(
                children: [
                  // ── Left arrow / back to no-color ───────────────────
                  if (controller.isBackgroundColorPost.value)
                    GestureDetector(
                      onTap: () {
                        controller.isBackgroundColorPost.value = false;
                        controller.postBackgroundColor.value =
                            postListColor.first;
                        controller.activeBackground.value = null;
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Icon(Icons.chevron_left,
                            size: 20,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                      ),
                    ),
                  // ── Color squares ───────────────────────────────────
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: postListColor.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            controller.isBackgroundColorPost.value &&
                                controller.postBackgroundColor.value ==
                                    postListColor[index] &&
                                index != 0;
                        final isFirst = index == 0;
                        return GestureDetector(
                          onTap: () {
                            controller.activeBackground.value = null;
                            if (isFirst) {
                              controller.isBackgroundColorPost.value = false;
                            } else {
                              controller.isBackgroundColorPost.value = true;
                              controller.postBackgroundColor.value =
                                  postListColor[index];
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
                                        ? (isDark
                                            ? Colors.grey.shade600
                                            : Colors.grey.shade300)
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
                                        color: isDark
                                            ? Colors.grey.shade300
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  // ── Grid icon — opens "Choose background" sheet ─────
                  GestureDetector(
                    onTap: () => _showChooseBackgroundSheet(context),
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(Icons.grid_view_rounded,
                          size: 18,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CHOOSE BACKGROUND SHEET — Facebook-style 5-column grid
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header: "Choose background" + X ────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Choose background'.tr,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textColor, size: 22),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color:
                      isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
                // ── Scrollable content ─────────────────────────────
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // ┌─────────────────────────────────────────────
                      // │  "No background" button
                      // └─────────────────────────────────────────────
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: GestureDetector(
                          onTap: () {
                            controller.isBackgroundColorPost.value = false;
                            controller.postBackgroundColor.value =
                                postListColor.first;
                            controller.activeBackground.value = null;
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !controller
                                        .isBackgroundColorPost.value
                                    ? PRIMARY_COLOR
                                    : (isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300),
                                width: !controller
                                        .isBackgroundColorPost.value
                                    ? 2.5
                                    : 1,
                              ),
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100,
                            ),
                            child: Center(
                              child: Text(
                                'No background'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: sectionLabel,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ┌─────────────────────────────────────────────
                      // │  GRADIENT / DECORATIVE section
                      // └─────────────────────────────────────────────
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 8),
                        child: Text(
                          'Decorative'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: sectionLabel,
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: postGradientBackgrounds.length,
                        itemBuilder: (context, index) {
                          final bg = postGradientBackgrounds[index];
                          final isSelected =
                              controller.isBackgroundColorPost.value &&
                                  controller.activeBackground.value != null &&
                                  controller.activeBackground.value!
                                          .storageValue ==
                                      bg.storageValue;

                          return GestureDetector(
                            onTap: () {
                              controller.isBackgroundColorPost.value = true;
                              controller.activeBackground.value = bg;
                              controller.postBackgroundColor.value =
                                  bg.primaryColor;
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: bg.gradient,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? PRIMARY_COLOR
                                      : Colors.transparent,
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
  //  MEDIA PREVIEW — File checking states + approved files
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildMediaPreview(BuildContext context, bool isDark) {
    return Obx(() {
      final hasFiles = controller.xfiles.value.isNotEmpty ||
          controller.fileCheckingStates.isNotEmpty;
      if (!hasFiles) return const SizedBox.shrink();

      final isSimpleLayout =
          controller.selectedMediaLayout.value?.title == 'none' ||
              controller.selectedMediaLayout.value?.title == null ||
              controller.xfiles.value.any((file) => file.path
                  .toLowerCase()
                  .endsWithAny(
                      ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv']));

      if (isSimpleLayout) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: controller.fileCheckingStates.isNotEmpty
                ? controller.fileCheckingStates.length
                : controller.xfiles.value.length,
            itemBuilder: (context, index) {
              // ── Checking state ──────────────────────────────────────
              if (controller.fileCheckingStates.isNotEmpty) {
                final state = controller.fileCheckingStates[index];
                return _MediaThumbnail(
                  filePath: state.filePath,
                  isChecking: state.isChecking,
                  isPassed: state.isPassed,
                  isFailed: state.isFailed,
                  isDark: isDark,
                );
              }
              // ── Approved files ──────────────────────────────────────
              final filePath = controller.xfiles.value[index].path;
              final isVideo = filePath.toLowerCase().endsWithAny(
                  ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv']);
              return Stack(
                children: [
                  isVideo
                      ? FutureBuilder<String?>(
                          future: controller.generateThumbnail(filePath),
                          builder: (context, snapshot) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    controller.videoPlayerController != null
                                        ? VideoPlayer(controller
                                            .videoPlayerController!)
                                        : const Center(
                                            child: Icon(Icons.videocam,
                                                color: Colors.white54)),
                              ),
                            );
                          },
                        )
                      : Container(
                          margin: const EdgeInsets.all(6),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(filePath)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  // ── Remove button ───────────────────────────────────
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        controller.xfiles.value.removeAt(index);
                        controller.processedFileData.removeAt(index);
                        controller.xfiles.refresh();
                        controller.processedFileData.refresh();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // ── Layout preview ──────────────────────────────────────────────
      if (controller.xfiles.value.isNotEmpty) {
        return PrimaryFileMediaComponent(
          mediaUrlList:
              controller.xfiles.value.map((e) => e.path).toList(),
          mediaLayout:
              controller.selectedMediaLayout.value?.title ?? '',
          onTapRemoveMediaFile: () {},
        );
      }
      return const SizedBox.shrink();
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BOTTOM TOOLBAR — Horizontal icon row (Facebook-style)
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBottomToolbar(BuildContext context, bool isDark,
      Color textColor, Color subtitleColor, Color dividerColor) {
    return Obx(() {
      // Action items config — horizontal icons
      final actions = <_ActionItem>[
        if (!controller.isBackgroundColorPost.value)
          _ActionItem(
            icon: Icons.photo_library_rounded,
            label: 'Photo/video'.tr,
            color: const Color(0xFF4CAF50),
            trailing: controller.xfiles.value.isNotEmpty
                ? '${controller.xfiles.value.length}'
                : null,
            onTap: () => controller.pickFiles(),
          ),
        _ActionItem(
          icon: Icons.person_add_alt_1_rounded,
          label: 'Tag people'.tr,
          color: const Color(0xFF2196F3),
          onTap: () => Get.toNamed(Routes.TAG_PEOPLE),
        ),
        _ActionItem(
          icon: Icons.emoji_emotions_rounded,
          label: 'Feeling/activity'.tr,
          color: const Color(0xFFFFC107),
          onTap: () async {
            final result = await Get.toNamed(Routes.FEELINGS);
            if (result != null && result is PostFeeling) {
              controller.feelingName.value = result;
            }
          },
        ),
        _ActionItem(
          icon: Icons.location_on_rounded,
          label: 'Check in'.tr,
          color: const Color(0xFFFF5722),
          onTap: () async {
            final result = await Get.toNamed(Routes.CHECKIN);
            if (result != null && result is AllLocation) {
              controller.locationName.value = result;
            }
          },
        ),
        if (!controller.isBackgroundColorPost.value)
          _ActionItem(
            icon: Icons.videocam_rounded,
            label: 'Live video'.tr,
            color: const Color(0xFFE91E63),
            onTap: () => Get.offNamed(Routes.GO_LIVE),
          ),
        _ActionItem(
          icon: Icons.text_fields_rounded,
          label: 'Aa'.tr,
          color: const Color(0xFF607D8B),
          onTap: () {
            // Toggle background color mode
            if (controller.isBackgroundColorPost.value) {
              controller.isBackgroundColorPost.value = false;
              controller.postBackgroundColor.value = postListColor.first;
            } else if (controller.xfiles.value.isEmpty) {
              controller.isBackgroundColorPost.value = true;
              controller.postBackgroundColor.value = postListColor[1];
            }
          },
        ),
        if (!controller.isBackgroundColorPost.value)
          _ActionItem(
            icon: Icons.flag_rounded,
            label: 'Life Event'.tr,
            color: const Color(0xFF9C27B0),
            onTap: () => Get.toNamed(Routes.EVENT),
          ),
      ];

      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
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
              // ── Drag handle ──────────────────────────────────────
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade600
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              // ── Horizontal icon row ─────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actions
                      .map((action) => _ToolbarIcon(
                            icon: action.icon,
                            color: action.color,
                            badge: action.trailing,
                            onTap: action.onTap,
                          ))
                      .toList(),
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
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _ReactionIcon(String reactionPath) {
    return Image(
      height: 16,
      image: NetworkImage((reactionPath).formatedFeelingUrl),
    );
  }
}

// =============================================================================
//  Private Widgets
// =============================================================================

/// Privacy pill — small rounded chip with icon + label + dropdown arrow
class _PrivacyPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _PrivacyPill({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3A3B3C) : const Color(0xFFE4E6EB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isDark ? Colors.white : Colors.black87),
            const SizedBox(width: 5),
            Text(
              label,
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
  }
}

/// Media thumbnail with checking state overlay
class _MediaThumbnail extends StatelessWidget {
  final String filePath;
  final bool isChecking;
  final bool isPassed;
  final bool isFailed;
  final bool isDark;

  const _MediaThumbnail({
    required this.filePath,
    required this.isChecking,
    required this.isPassed,
    required this.isFailed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(6),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(File(filePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isChecking)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black54,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                    color: Colors.green, strokeWidth: 3),
              ),
            ),
          ),
        if (isPassed)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black38,
              ),
              child: const Center(
                child:
                    Icon(Icons.check_circle, color: Colors.green, size: 36),
              ),
            ),
          ),
        if (isFailed)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black54,
              ),
              child: const Center(
                child: Icon(Icons.cancel, color: Colors.red, size: 36),
              ),
            ),
          ),
      ],
    );
  }
}

/// Horizontal toolbar icon — circular tap target with colorful icon + optional badge
class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const _ToolbarIcon({
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 42,
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 26, color: color),
            if (badge != null)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Private data classes

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final String? trailing;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    this.trailing,
    required this.onTap,
  });
}

class _PrivacyOptionData {
  final IconData icon;
  final String label;
  final String subtitle;
  final String value;

  const _PrivacyOptionData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
  });
}
