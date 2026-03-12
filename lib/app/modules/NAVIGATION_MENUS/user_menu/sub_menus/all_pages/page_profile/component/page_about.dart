import 'package:flutter/material.dart';
import '../../../../../../../utils/url_utils.dart';
import '../controllers/page_profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class PageAboutComponent extends StatefulWidget {
  const PageAboutComponent({super.key, required this.controller});
  final PageProfileController controller;

  @override
  State<PageAboutComponent> createState() => _AboutComponentState();
}

class _AboutComponentState extends State<PageAboutComponent> {
  // Launch URL for WhatsApp
  _launchWhatsapp() async {
    var whatsapp =
        widget.controller.pageProfileModel.value?.pageDetails?.whatsappNumber ??
            '';
    var whatsappAndroid =
        Uri.parse('whatsapp://send?phone=$whatsapp&text=hello');
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('WhatsApp is not installed on the device'.tr),
        ),
      );
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

  // Reusable widget for displaying section rows
  Widget _buildInfoRow(Icon icon, String text, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
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
              const Icon(Icons.info_rounded, size: 30, color: Colors.grey),
              pageDetails?.description ?? 'Not available',
              () {},
            ),

            // Follower Count Section
            _buildInfoRow(
              const Icon(Icons.people, size: 30, color: Colors.grey),
              '${pageDetails?.followerCount ?? 0} people follow this',
              () {},
            ),

            // Location Section
            _buildInfoRow(
              const Icon(Icons.location_on, size: 30, color: Colors.grey),
              (pageDetails?.location.isNotEmpty == true)
                  ? (pageDetails?.location as List).join(', ')
                  : 'Not available',
              () {},
            ),

            // Website Section
            _buildInfoRow(
              const Icon(Icons.language, size: 30, color: Colors.grey),
              pageDetails?.website ?? 'Not available',
              () {
                final website = pageDetails?.website ?? '';
                if (website.isNotEmpty) {
                  UriUtils.launchUrlInBrowser(website);
                }
              },
            ),

            // Phone Number Section
            _buildInfoRow(
              const Icon(Icons.phone, size: 30, color: Colors.grey),
              pageDetails?.phoneNumber ?? 'Not available',
              () {
                final phoneNumber = pageDetails?.phoneNumber ?? '';
                if (phoneNumber.isNotEmpty) {
                  UriUtils.launchUrlInBrowser('tel:$phoneNumber');
                }
              },
            ),

            // Email Section
            _buildInfoRow(
              const Icon(Icons.email, size: 30, color: Colors.grey),
              pageDetails?.email ?? 'Not available',
              _launchEmail,
            ),

            // WhatsApp Section
            _buildInfoRow(
              const Icon(Icons.chat_bubble, size: 30, color: Colors.grey),
              pageDetails?.whatsappNumber ?? 'Not available',
              _launchWhatsapp,
            ),
          ],
        ),
      ),
    );
  }
}
