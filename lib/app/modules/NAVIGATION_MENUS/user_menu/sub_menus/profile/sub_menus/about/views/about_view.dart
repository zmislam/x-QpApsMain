import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../extension/date_time_extension.dart';
import '../../../../../../../../extension/string/string.dart';
import '../../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../../config/constants/color.dart';
import '../../../../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../../../../routes/app_pages.dart';
import '../../../../../../../../utils/url_utils.dart';
import '../controller/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getUserALLData();
    final textPrimary = FeedDesignTokens.textPrimary(context);
    final textSecondary = FeedDesignTokens.textSecondary(context);
    final bgColor = FeedDesignTokens.cardBg(context);
    final dividerColor = FeedDesignTokens.divider(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Edit profile'.tr,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: dividerColor, height: 0.5),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ═══════════════════ Cover + Profile Pic ════════════════════
                  _buildCoverAndProfilePic(context, textPrimary, textSecondary),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Intro (Bio + Pinned) ══════════════════
                  _buildIntroSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Personal Details ══════════════════════
                  _buildPersonalDetailsSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Work ══════════════════════════════════
                  _buildWorkSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Education ═════════════════════════════
                  _buildEducationSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Places Lived ═══════════════════════════
                  _buildPlacesLivedSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Contact Info ═══════════════════════════
                  _buildContactInfoSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Website ════════════════════════════════
                  _buildWebsiteSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ About You ═════════════════════════════
                  _buildAboutSection(context, textPrimary, textSecondary, dividerColor),

                  Divider(height: 0.5, color: dividerColor),

                  // ═══════════════════ Nickname ══════════════════════════════
                  _buildNicknameSection(context, textPrimary, textSecondary, dividerColor),

                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Cover + Profile Pic
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCoverAndProfilePic(BuildContext context, Color textPrimary, Color textSecondary) {
    final profile = controller.profileModel.value;
    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover photo
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              image: profile?.cover_pic != null && profile!.cover_pic!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profile.cover_pic!.formatedProfileUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profile?.cover_pic == null || profile!.cover_pic!.isEmpty
                ? Center(child: Icon(Icons.image, size: 48, color: Colors.grey.shade500))
                : null,
          ),
          // Camera icon on cover
          Positioned(
            bottom: 70,
            right: 12,
            child: _cameraCircle(
              onTap: () {
                // Use existing profile controller for cover photo upload
                try {
                  final profileCtrl = Get.find<dynamic>(tag: 'ProfileController');
                  profileCtrl.getImageFromGallery(isCoverPic: true);
                } catch (_) {}
              },
            ),
          ),
          // Profile pic
          Positioned(
            bottom: 0,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: FeedDesignTokens.cardBg(context), width: 4),
              ),
              child: CircleAvatar(
                radius: 54,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: profile?.profile_pic != null && profile!.profile_pic!.isNotEmpty
                    ? NetworkImage(profile.profile_pic!.formatedProfileUrl)
                    : null,
                child: profile?.profile_pic == null || profile!.profile_pic!.isEmpty
                    ? Icon(Icons.person, size: 48, color: Colors.grey.shade500)
                    : null,
              ),
            ),
          ),
          // Camera icon on profile pic
          Positioned(
            bottom: 2,
            left: 96,
            child: _cameraCircle(
              onTap: () {
                try {
                  final profileCtrl = Get.find<dynamic>(tag: 'ProfileController');
                  profileCtrl.getImageFromGallery(isCoverPic: false);
                } catch (_) {}
              },
              size: 28,
              iconSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraCircle({required VoidCallback onTap, double size = 34, double iconSize = 18}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade800.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.camera_alt, color: Colors.white, size: iconSize),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Intro Section (Bio + Pinned Details)
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildIntroSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Intro'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          const SizedBox(height: 16),

          // Bio row
          _buildEditableRow(
            context: context,
            icon: Icons.auto_awesome,
            label: 'Bio'.tr,
            value: profile?.user_bio,
            privacy: profile?.privacy?.user_bio,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () {
              Get.toNamed(Routes.ADD_BIO, arguments: {
                'bio': profile?.user_bio,
                'privacy': profile?.privacy?.user_bio,
              });
            },
          ),

          const SizedBox(height: 12),

          // Pinned details row
          _buildEditableRow(
            context: context,
            icon: Icons.push_pin_outlined,
            label: 'Pinned details'.tr,
            value: profile?.present_town ?? profile?.home_town,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onEdit: () {
              Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {
                'isEditing': true,
                'id': 1,
                'model': profile,
              });
            },
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Personal Details Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildPersonalDetailsSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal details'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          const SizedBox(height: 16),

          // Current city / location
          if (profile?.present_town != null)
            _buildEditableRow(
              context: context,
              icon: Icons.location_on,
              label: profile!.present_town!,
              privacy: profile.privacy?.present_town,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {
                  'id': 1,
                  'model': profile,
                });
              },
            ),

          // Hometown
          if (profile?.home_town != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.home_outlined,
              label: profile!.home_town!,
              privacy: profile.privacy?.home_town,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {
                  'id': 2,
                  'model': profile,
                });
              },
            ),
          ],

          // Birthday
          if (profile?.date_of_birth != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.cake_outlined,
              label: (profile!.date_of_birth.toString().split('T').first).toFormatDateOfBirth(),
              privacy: profile.privacy?.dob,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_BIRTH_DATE, arguments: {
                  'dob': profile.date_of_birth.toString().split('T').first,
                  'privacy': profile.privacy?.dob,
                });
              },
            ),
          ],

          // Relationship
          if (profile?.relation_status != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.favorite_border,
              label: profile!.relation_status!,
              privacy: profile.privacy?.relationship,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_RELATIONSHIP, arguments: {
                  'relationship': profile.relation_status,
                  'privacy': profile.privacy?.relationship,
                });
              },
            ),
          ],

          // Gender
          if (profile?.gender?.gender_name != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.person_outline,
              label: profile!.gender!.gender_name!,
              privacy: profile.privacy?.gender,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_GENDER, arguments: {
                  'gender': profile.gender?.gender_name,
                  'privacy': profile.privacy?.gender,
                });
              },
            ),
          ],

          // Language
          if (profile?.language != null && profile!.language!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.language,
              label: profile.language!.map((l) => l.language ?? '').where((s) => s.isNotEmpty).join(' · '),
              privacy: 'friends',
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.ADD_LANGUAGE);
              },
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Work Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildWorkSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final workplaces = controller.profileModel.value?.userWorkplaces ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Work'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ADD_WORK_PLACE),
                child: Row(
                  children: [
                    Text(
                      'Add Workplace'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (workplaces.isEmpty)
            _buildPlaceholderRow(
              icon: Icons.work_outline,
              label: 'Work experience'.tr,
              textSecondary: textSecondary,
            ),
          ...workplaces.map((wp) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildWorkItem(
                  context: context,
                  orgName: (wp.org_name ?? '').capitalizeFirstOfEach,
                  designation: wp.designation,
                  fromDate: wp.from_date,
                  toDate: wp.to_date,
                  privacy: wp.privacy,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onEdit: () => Get.toNamed(Routes.ADD_WORK_PLACE, arguments: wp),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWorkItem({
    required BuildContext context,
    required String orgName,
    String? designation,
    String? fromDate,
    String? toDate,
    String? privacy,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onEdit,
  }) {
    String dateRange = '';
    if (fromDate != null && fromDate.isNotEmpty) {
      dateRange = fromDate.split('T')[0].toWorkPlaceDuration();
      if (toDate != null && toDate.isNotEmpty) {
        dateRange += ' - ${toDate.split('T')[0].toWorkPlaceDuration()}';
      } else {
        dateRange += ' - Present';
      }
    }
    String subtitle = '';
    if (designation != null && designation.isNotEmpty) {
      subtitle = designation.capitalizeFirstOfEach;
      if (dateRange.isNotEmpty) subtitle += ' · $dateRange';
    } else if (dateRange.isNotEmpty) {
      subtitle = dateRange;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.work_outline, size: 24, color: textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orgName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (privacy != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(_privacyIcon(privacy), size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _privacyLabel(privacy),
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.edit_outlined, size: 20, color: textSecondary),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Education Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildEducationSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final education = controller.profileModel.value?.educationWorkplaces ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Education'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ADD_EDUCATION),
                child: Row(
                  children: [
                    Text(
                      'Add Education'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (education.isEmpty)
            _buildPlaceholderRow(
              icon: Icons.school_outlined,
              label: 'Secondary school or college'.tr,
              textSecondary: textSecondary,
            ),
          ...education.map((edu) {
            String dateRange = '';
            if (edu.startDate != null && edu.startDate!.isNotEmpty) {
              dateRange = edu.startDate!.split('T')[0].toWorkPlaceDuration();
              if (edu.endDate != null && edu.endDate!.isNotEmpty) {
                dateRange += ' - ${edu.endDate!.split('T')[0].toWorkPlaceDuration()}';
              } else {
                dateRange += ' - Present';
              }
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined, size: 24, color: textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (edu.institute_name ?? '').capitalizeFirstOfEach,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (dateRange.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              dateRange,
                              style: TextStyle(fontSize: 13, color: textSecondary),
                            ),
                          ),
                        if (edu.privacy != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Icon(_privacyIcon(edu.privacy), size: 14, color: textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  _privacyLabel(edu.privacy),
                                  style: TextStyle(fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.ADD_EDUCATION, arguments: edu),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.edit_outlined, size: 20, color: textSecondary),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Places Lived Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildPlacesLivedSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Places Lived'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              if (profile?.present_town == null || profile?.home_town == null)
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {
                      'isEditing': true,
                      'id': profile?.home_town == null ? 2 : 1,
                      'model': profile,
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        profile?.present_town == null && profile?.home_town == null
                            ? 'Add Place'.tr
                            : profile?.present_town == null
                                ? 'Add Current Place'.tr
                                : 'Add Home Town'.tr,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (profile?.present_town != null)
            _buildEditableRow(
              context: context,
              icon: Icons.location_on,
              label: profile!.present_town!,
              sublabel: 'Current City'.tr,
              privacy: profile.privacy?.present_town,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {'id': 1, 'model': profile});
              },
            ),

          if (profile?.present_town != null && profile?.home_town != null)
            const SizedBox(height: 12),

          if (profile?.home_town != null)
            _buildEditableRow(
              context: context,
              icon: Icons.location_on,
              label: profile!.home_town!,
              sublabel: 'Home Town'.tr,
              privacy: profile.privacy?.home_town,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_PLACESLIVED, arguments: {'id': 2, 'model': profile});
              },
            ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Contact Info Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildContactInfoSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    final phones = profile?.phone_list ?? [];
    final emails = profile?.email_list ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Info'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ADD_CONTACT),
                child: Row(
                  children: [
                    Text(
                      'Add Contact'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...phones.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildDetailRowWithActions(
                  icon: Icons.phone_outlined,
                  value: p.phone ?? '',
                  sublabel: 'Mobile'.tr,
                  privacy: p.privacy,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onDelete: () => controller.onTapDeletePhonePost(p.id ?? ''),
                ),
              )),
          ...emails.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildDetailRowWithActions(
                  icon: Icons.email_outlined,
                  value: e.email ?? '',
                  sublabel: 'Email'.tr,
                  privacy: e.privacy,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onDelete: () => controller.onTapDeleteEmailPost(e.id ?? ''),
                ),
              )),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Website Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildWebsiteSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final websites = controller.profileModel.value?.websites ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Website'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ADD_WEBSITE),
                child: Row(
                  children: [
                    Text(
                      'Websites and Other links'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...websites.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.link, size: 22, color: textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => UriUtils.launchUrlInBrowser(w.website_url ?? ''),
                            child: Text(
                              w.website_url ?? '',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PRIMARY_COLOR),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (w.socialMedia?.media_name != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                w.socialMedia!.media_name!,
                                style: TextStyle(fontSize: 12, color: textSecondary),
                              ),
                            ),
                          if (w.privacy != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Icon(_privacyIcon(w.privacy), size: 14, color: textSecondary),
                                  const SizedBox(width: 4),
                                  Text(_privacyLabel(w.privacy), style: TextStyle(fontSize: 12, color: textSecondary)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.ADD_WEBSITE, arguments: w),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.edit_outlined, size: 20, color: textSecondary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // About Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildAboutSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About You'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              if (profile?.user_about == null)
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.ADD_ABOUTYOURSELF, arguments: {
                      'aboutyou': profile?.user_about,
                      'privacy': profile?.privacy?.about,
                    });
                  },
                  child: const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                ),
            ],
          ),
          if (profile?.user_about != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.info_outline,
              label: profile!.user_about!,
              privacy: profile.privacy?.about,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.ADD_ABOUTYOURSELF, arguments: {
                  'aboutyou': profile.user_about,
                  'privacy': profile.privacy?.about,
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Nickname Section
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildNicknameSection(BuildContext context, Color textPrimary, Color textSecondary, Color dividerColor) {
    final profile = controller.profileModel.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nickname'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              if (profile?.user_nickname == null)
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.EDIT_NICKNAME, arguments: {
                      'nickname': profile?.user_nickname,
                      'privacy': profile?.privacy?.nickname,
                    });
                  },
                  child: const Icon(Icons.add_circle, color: PRIMARY_COLOR, size: 18),
                ),
            ],
          ),
          if (profile?.user_nickname != null) ...[
            const SizedBox(height: 12),
            _buildEditableRow(
              context: context,
              icon: Icons.badge_outlined,
              label: profile!.user_nickname!,
              privacy: profile.privacy?.nickname,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onEdit: () {
                Get.toNamed(Routes.EDIT_NICKNAME, arguments: {
                  'nickname': profile.user_nickname,
                  'privacy': profile.privacy?.nickname,
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Shared Helpers
  // ──────────────────────────────────────────────────────────────────────────

  /// Editable row: icon + label (bold) + optional value + privacy subtext + pencil
  Widget _buildEditableRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    String? value,
    String? sublabel,
    String? privacy,
    required Color textPrimary,
    required Color textSecondary,
    required VoidCallback onEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 22, color: textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (value != null) ...[
                Text(
                  label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: textPrimary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ] else ...[
                Text(
                  label,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (sublabel != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(sublabel, style: TextStyle(fontSize: 13, color: textSecondary)),
                ),
              if (privacy != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: [
                      Icon(_privacyIcon(privacy), size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _privacyLabel(privacy),
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.edit_outlined, size: 20, color: textSecondary),
          ),
        ),
      ],
    );
  }

  /// Detail row with delete action (for contacts)
  Widget _buildDetailRowWithActions({
    required IconData icon,
    required String value,
    String? sublabel,
    String? privacy,
    required Color textPrimary,
    required Color textSecondary,
    VoidCallback? onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 22, color: textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (sublabel != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(sublabel, style: TextStyle(fontSize: 13, color: textSecondary)),
                ),
              if (privacy != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(_privacyIcon(privacy), size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(_privacyLabel(privacy), style: TextStyle(fontSize: 12, color: textSecondary)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (onDelete != null)
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.more_horiz, size: 20, color: textSecondary),
            ),
          ),
      ],
    );
  }

  /// Placeholder row (greyed-out item with icon + label)
  Widget _buildPlaceholderRow({
    required IconData icon,
    required String label,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 22, color: textSecondary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 15, color: textSecondary)),
        ],
      ),
    );
  }

  /// Privacy icon from string
  IconData _privacyIcon(String? privacy) {
    if (privacy == null) return Icons.public;
    final p = privacy.toLowerCase();
    if (p == 'public') return Icons.public;
    if (p == 'friends') return Icons.group;
    return Icons.lock;
  }

  /// Privacy label from string
  String _privacyLabel(String? privacy) {
    if (privacy == null) return 'Public';
    final p = privacy.toLowerCase();
    if (p == 'public') return 'Public';
    if (p == 'friends') return 'Your friends';
    if (p == 'only_me' || p == 'onlyme') return 'Only me';
    return privacy.replaceAll('_', ' ').capitalize ?? privacy;
  }
}
