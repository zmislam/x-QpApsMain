import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadableTextDoc extends StatefulWidget {
  final String? docFileName;
  final String? fileUrl;

  const DownloadableTextDoc({
    Key? key,
    this.docFileName,
    this.fileUrl,
  }) : super(key: key);

  @override
  _DownloadableTextDocState createState() => _DownloadableTextDocState();
}

class _DownloadableTextDocState extends State<DownloadableTextDoc> {
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
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                widget.docFileName ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: _isHovering
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)
                    : const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
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
