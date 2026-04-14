import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_publish_controller.dart';
import '../widgets/caption_editor.dart';
import '../widgets/thumbnail_picker.dart';
import '../widgets/ab_thumbnail_selector.dart';
import '../widgets/location_tag_picker.dart';
import '../widgets/people_tag_picker.dart';
import '../widgets/topic_selector.dart';
import '../widgets/privacy_selector.dart';
import '../widgets/comment_control_selector.dart';
import '../widgets/remix_permission_toggle.dart';
import '../widgets/download_permission_toggle.dart';
import '../widgets/cross_post_toggles.dart';
import '../widgets/schedule_picker.dart';
import '../widgets/collab_invite_picker.dart';

/// Reels V2 Publish View — final step before posting.
/// Composed of modular widgets for each setting section.
class ReelsPublishView extends GetView<ReelsPublishController> {
  const ReelsPublishView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.autoSaveDraft();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Reel'),
          actions: [
            Obx(() => controller.isPublishing.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: controller.publish,
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ─── Video Preview + Caption ─────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video thumbnail preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 100,
                      height: 140,
                      color: Colors.grey[900],
                      child: controller.videoFile != null
                          ? const Center(
                              child: Icon(Icons.play_circle_outline,
                                  color: Colors.white54, size: 36),
                            )
                          : const Center(
                              child: Icon(Icons.videocam_off,
                                  color: Colors.white24),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Caption
                  Expanded(
                    child: CaptionEditor(
                      controller: controller.captionController,
                      maxLength: ReelsPublishController.maxCaptionLength,
                      onChanged: controller.updateCaption,
                      onHashtagTap: controller.insertHashtag,
                      onMentionTap: controller.insertMention,
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // ─── Thumbnail ───────────────────────────
              const _SectionHeader(title: 'Cover'),
              ThumbnailPicker(
                onFrameSelected: controller.selectThumbnailFromFrame,
                onCustomSelected: controller.selectCustomThumbnail,
              ),

              // ─── A/B Thumbnail ───────────────────────
              Obx(() => controller.useAbThumbnail.value
                  ? AbThumbnailSelector(
                      thumbnailA: controller.abThumbnailA.value,
                      thumbnailB: controller.abThumbnailB.value,
                      onSelectA: controller.setAbThumbnailA,
                      onSelectB: controller.setAbThumbnailB,
                      onClear: controller.clearAbThumbnail,
                    )
                  : TextButton.icon(
                      onPressed: () => controller.useAbThumbnail.value = true,
                      icon: const Icon(Icons.science_outlined, size: 18),
                      label: const Text('A/B Test Thumbnail'),
                    )),

              const Divider(height: 24),

              // ─── Tag People ──────────────────────────
              const _SectionHeader(title: 'Tag People'),
              PeopleTagPicker(
                taggedPeople: controller.taggedPeople,
                onAdd: controller.addTaggedPerson,
                onRemove: controller.removeTaggedPerson,
              ),

              const Divider(height: 24),

              // ─── Location ────────────────────────────
              LocationTagPicker(
                locationName: controller.locationName,
                onSelected: controller.setLocation,
                onClear: controller.clearLocation,
              ),

              const Divider(height: 24),

              // ─── Topics ──────────────────────────────
              const _SectionHeader(title: 'Topics'),
              TopicSelector(
                selectedTopicIds: controller.selectedTopicIds,
                selectedTopicNames: controller.selectedTopicNames,
                maxTopics: ReelsPublishController.maxTopics,
                onToggle: controller.toggleTopic,
              ),

              const Divider(height: 24),

              // ─── Privacy ─────────────────────────────
              PrivacySelector(privacy: controller.privacy),

              // ─── Comment Control ─────────────────────
              CommentControlSelector(
                  commentPermission: controller.commentPermission),

              const Divider(height: 24),

              // ─── Remix / Download Toggles ────────────
              RemixPermissionToggle(allowRemix: controller.allowRemix),
              DownloadPermissionToggle(
                  allowDownload: controller.allowDownload),

              const Divider(height: 24),

              // ─── Cross-Post ──────────────────────────
              CrossPostToggles(
                postToFeed: controller.crossPostToFeed,
                postToStories: controller.crossPostToStories,
              ),

              const Divider(height: 24),

              // ─── Collab Invite ───────────────────────
              CollabInvitePicker(
                collabUserName: controller.collabUserName,
                onInvite: controller.setCollabUser,
                onRemove: controller.removeCollab,
              ),

              const Divider(height: 24),

              // ─── Schedule ────────────────────────────
              SchedulePicker(
                isScheduled: controller.isScheduled,
                scheduledDate: controller.scheduledDate,
                onSchedule: controller.setSchedule,
                onClear: controller.clearSchedule,
              ),

              const SizedBox(height: 16),

              // ─── Action Buttons ──────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.saveAsDraft,
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.isPublishing.value
                              ? null
                              : controller.publish,
                          child: Text(
                            controller.isScheduled.value
                                ? 'Schedule'
                                : 'Share',
                          ),
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ─── Background Upload Indicator ─────────
              Obx(() => controller.isUploadingInBackground.value
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => Text(
                                  'Uploading... ${(controller.uploadProgress.value * 100).toInt()}%',
                                )),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}
