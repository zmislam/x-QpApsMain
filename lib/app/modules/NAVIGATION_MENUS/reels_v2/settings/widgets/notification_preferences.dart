import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class NotificationPreferences extends GetView<ReelsSettingsController> {
  const NotificationPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          _notifTile(
            icon: Icons.favorite,
            title: 'Likes',
            subtitle: 'When someone likes your reel',
            value: controller.notifLikes.value,
            key: 'likes',
          ),
          _notifTile(
            icon: Icons.comment,
            title: 'Comments',
            subtitle: 'When someone comments on your reel',
            value: controller.notifComments.value,
            key: 'comments',
          ),
          _notifTile(
            icon: Icons.alternate_email,
            title: 'Mentions',
            subtitle: 'When someone mentions you in a reel',
            value: controller.notifMentions.value,
            key: 'mentions',
          ),
          _notifTile(
            icon: Icons.person_add,
            title: 'New Followers',
            subtitle: 'When someone follows you',
            value: controller.notifFollows.value,
            key: 'follows',
          ),
          _notifTile(
            icon: Icons.loop,
            title: 'Remixes',
            subtitle: 'When someone remixes your reel',
            value: controller.notifRemixes.value,
            key: 'remixes',
          ),
          _notifTile(
            icon: Icons.group_add,
            title: 'Collaboration Requests',
            subtitle: 'When someone invites you to collaborate',
            value: controller.notifCollabRequests.value,
            key: 'collabRequests',
          ),
          _notifTile(
            icon: Icons.star,
            title: 'Milestones',
            subtitle: 'Achievement notifications',
            value: controller.notifMilestones.value,
            key: 'milestones',
          ),
        ],
      );
    });
  }

  Widget _notifTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required String key,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, size: 22),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: (v) => controller.setNotifPref(key, v),
    );
  }
}
