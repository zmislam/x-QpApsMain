import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/url_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/admin_page_controller.dart';
import '../../../../../../../config/constants/app_assets.dart';

class AboutComponent extends StatefulWidget {
  const AboutComponent({super.key, required this.controller});
  final AdminPageController controller;

  @override
  State<AboutComponent> createState() => _AboutComponentState();
}

class _AboutComponentState extends State<AboutComponent> {
  // Launch URL for WhatsApp
  _launchWhatsapp() async {
    final whatsapp =
        widget.controller.pageProfileModel.value?.pageDetails?.whatsappNumber ??
            '';
    final whatsappUri = Uri.parse('whatsapp://send?phone=$whatsapp&text=hello');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      _showSnackBar('WhatsApp is not installed on the device');
    }
  }

  // Launch Email
  _launchEmail() async {
    try {
      final email = Uri(scheme: 'mailto');
      await launchUrl(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Launch URL for Phone and Website

  // Show SnackBar
  _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Reusable widget for displaying section rows
  Widget _buildInfoRow(Widget leadingIcon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            leadingIcon,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 18, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageDetails = widget.controller.pageProfileModel.value?.pageDetails;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Section
            _buildInfoRow(
              const Icon(Icons.info_rounded, size: 27, color: Colors.grey),
              pageDetails?.description ?? 'Not available',
              () {},
            ),

            // Follower Count Section
            _buildInfoRow(
              Image.asset(AppAssets.FOLLOWERS_ICON, width: 25),
              '${pageDetails?.followerCount ?? 0} people follow this',
              () {},
            ),

            // Location Section
            _buildInfoRow(
              Image.asset(AppAssets.LOCATIONSLINE_ICON, height: 25),
              pageDetails?.location.first != ''
                  ? (pageDetails?.location as List).join(', ')
                  : 'Not available',
              () {},
            ),

            // Website Section
            _buildInfoRow(
              Image.asset(AppAssets.WEBSITE_ICON, height: 25),
              (pageDetails?.website != '')
                  ? (pageDetails?.website ?? 'Not available')
                  : 'Not available',
              () => UriUtils.launchUrlInBrowser(pageDetails?.website ?? ''),
            ),

            // Phone Number Section
            if (pageDetails?.phoneNumber?.isNotEmpty == true)
              _buildInfoRow(
                const Icon(Icons.phone, size: 30, color: Colors.grey),
                pageDetails?.phoneNumber ?? 'Not available',
                () {
                  UriUtils.launchUrlInBrowser(
                      'tel:${pageDetails?.phoneNumber}');
                  Get.back();
                },
              ),

            // Email Section
            if (pageDetails?.email?.isNotEmpty == true)
              _buildInfoRow(
                const Icon(Icons.email, size: 30, color: Colors.grey),
                pageDetails?.email ?? 'Not available',
                _launchEmail,
              ),

            // WhatsApp Section
            if (pageDetails?.whatsappNumber?.isNotEmpty == true)
              _buildInfoRow(
                Image.asset(AppAssets.WHATSAPP_ICON, height: 25),
                pageDetails?.whatsappNumber ?? 'Not available',
                _launchWhatsapp,
              ),
          ],
        ),
      ),
    );
  }
}
