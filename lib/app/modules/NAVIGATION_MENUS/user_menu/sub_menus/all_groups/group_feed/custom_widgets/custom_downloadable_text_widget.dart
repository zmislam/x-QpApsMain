import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadableText extends StatefulWidget {
  final String? fileName;
  final String? fileUrl;

  const DownloadableText({
    Key? key,
    this.fileName,
    this.fileUrl,
  }) : super(key: key);

  @override
  DownloadableTextState createState() => DownloadableTextState();
}

class DownloadableTextState extends State<DownloadableText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => _updateHovering(true),
          onExit: (_) => _updateHovering(false),
          child: InkWell(
            onTap: _openInBrowser,
            child: Text(
              widget.fileName ?? '',
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: _isHovering ? Colors.blue : Colors.black,
                decoration: _isHovering
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  void _updateHovering(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  void _openInBrowser() async {
    final Uri url = Uri.parse(widget.fileUrl ?? '');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Handle the case where the URL can't be launched
      debugPrint('Could not launch $url');
      // Optionally, show a message to the user or log the error
    }
  }
}
