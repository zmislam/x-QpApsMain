import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/url_utils.dart';
import '../edit_profile/popup_component.dart';
import '../../config/constants/app_assets.dart';
import '../../models/websites.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/sub_menus/about/controller/about_controller.dart';
import '../../routes/app_pages.dart';
import '../../config/constants/color.dart';

class WebsiteTile extends StatelessWidget {
  WebsiteTile({
    super.key,
    this.workIcon,
    required this.model,
  });

  final Websites model;
  final String? workIcon;
  AboutController aboutController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => UriUtils.launchUrlInBrowser(model.website_url ?? ''),
              child: Image.asset(
                model.socialMedia?.media_name == 'Youtube'
                    ? AppAssets.YOUTUBE
                    : model.socialMedia?.media_name == 'Facebook'
                        ? AppAssets.FACEBOOK
                        : model.socialMedia?.media_name == 'Linkedin'
                            ? AppAssets.LINKDIN
                            : model.socialMedia?.media_name == 'Instagram'
                                ? AppAssets.INSTAGRAM
                                : model.socialMedia?.media_name == 'Twitter'
                                    ? AppAssets.TWITTER
                                    : AppAssets.USER_WEBSITE_ICON,
                width: 40,
                height: 40,
                // color: PRIMARY_COLOR,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () =>
                        UriUtils.launchUrlInBrowser(model.website_url ?? ''),
                    child: Text(
                      model.website_url ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: model.website_url != null,
                    child: Text(model.socialMedia?.media_name ?? ''),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  model.privacy.toString() == 'public'
                      ? Icons.public
                      : model.privacy.toString() == 'friends'
                          ? Icons.group
                          : Icons.lock,
                  size: 20,
                  color: ENABLED_BORDER_COLOR,
                ),
                EditProfilePopUpMenu(
                  onTapDelete: () {
                    aboutController.onTapDeleteWebsitePost(model.id ?? '');
                  },
                  onTapEdit: () {
                    Get.toNamed(Routes.ADD_WEBSITE, arguments: model);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
