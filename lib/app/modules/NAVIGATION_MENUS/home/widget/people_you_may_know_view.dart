import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';
import '../../../../routes/app_pages.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';
import '../../friend/model/people_may_you_khnow.dart';
import '../controllers/home_controller.dart';

class PeopleYouMayKnowView extends GetView<HomeController> {
  const PeopleYouMayKnowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Hide entire section when no data
      if (controller.peopleMayYouKnowList.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        color: Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'People You May Know'.tr,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final tabCtrl = Get.find<TabViewController>();
                      final cred = LoginCredential();
                      if (!cred.getProfileSwitch()) {
                        tabCtrl.tabController.animateTo(2);
                      }
                    },
                    child: Text(
                      'See all'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.peopleMayYouKnowList.value.length,
                itemBuilder: (context, index) {
                  final person = controller.peopleMayYouKnowList.value[index];
                  return _CompactPersonCard(
                    person: person,
                    onAdd: () {
                      controller.sendFriendRequest(
                        index: index,
                        userId: person.id ?? '',
                      );
                    },
                    onDismiss: () {
                      controller.peopleMayYouKnowList.value.removeAt(index);
                      controller.peopleMayYouKnowList.refresh();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CompactPersonCard extends StatelessWidget {
  final PeopleMayYouKnowModel person;
  final VoidCallback onAdd;
  final VoidCallback onDismiss;

  const _CompactPersonCard({
    required this.person,
    required this.onAdd,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final name = '${person.first_name ?? ''} ${person.last_name ?? ''}'.trim();
    final imageUrl = (person.profile_pic ?? '').formatedProfileUrl;

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          // Profile image — tappable
          GestureDetector(
            onTap: () => Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
              'username': person.username,
              'isFromReels': 'false',
            }),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image(
                height: 90,
                width: 130,
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
                errorBuilder: (_, __, ___) => Container(
                  height: 90,
                  width: 130,
                  color: Colors.grey[200],
                  child: const Image(
                    image: AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          // Add Friend button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              height: 28,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Text('Add'.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Dismiss button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              height: 28,
              child: OutlinedButton(
                onPressed: onDismiss,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Text('Remove'.tr, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
