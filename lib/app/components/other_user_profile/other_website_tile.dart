import 'package:flutter/material.dart';
import '../../config/constants/app_assets.dart';
import '../../models/websites.dart';
import '../../config/constants/color.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherWebsiteTile extends StatelessWidget {
  const OtherWebsiteTile({
    super.key,
    this.workIcon,
    required this.model,
  });
  final Websites model;
  final String? workIcon;

  Future<void> _launchURL() async {
    String url = model.website_url ?? '';
    String mediaName = model.socialMedia?.media_name ?? '';

    switch (mediaName.toLowerCase()) {
      case 'youtube':
        url = 'vnd.youtube:$url';
        break;
      case 'facebook':
        url = 'fb://facewebmodal/f?href=$url';
        break;
      case 'linkedin':
        url = 'linkedin://profile/$url';
        break;
      case 'instagram':
        url = 'instagram://user?username=$url';
        break;
      case 'twitter':
        url = 'twitter://user?screen_name=$url';
        break;
      default:
        // For other or no specific social media, use the website URL directly
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
          return;
        }
        throw 'Could not launch $url';
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // If the specific app URL cannot be launched, try the web URL
      url = model.website_url ?? '';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
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
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _launchURL,
                    child: Text(
                      model.website_url ?? '',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Indicate clickable link
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: model.website_url != null,
                    child: Text(model.socialMedia?.media_name ?? ''),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
