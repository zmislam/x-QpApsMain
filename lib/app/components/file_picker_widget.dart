import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/custom_controllers/file_picker_controller.dart';
import 'package:get/get.dart';

class FilePickerWidget extends StatelessWidget {
  final FilePickerController controller;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final bool isRequired;
  final bool? viewOnly;
  final String requiredErrorMessage;

  const FilePickerWidget({
    Key? key,
    required this.controller,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.borderColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.textColor = Colors.grey,
    this.isRequired = false,
    this.requiredErrorMessage = 'Please select a file',
    this.viewOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (!(viewOnly ?? false)) {
                  controller.pickFile(); // no change!
                }
              },
              child: Container(
                height: height,
                width: width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: controller.errorMessage != null ? Colors.red : borderColor,
                  ),
                ),
                child: controller.hasFile || controller.hasNetworkFile
                    ? _FilePreview(
                  controller: controller,
                  borderRadius: borderRadius,
                  viewOnly: viewOnly ?? false,
                )
                    : _buildPlaceholder(),
              ),
            ),
            if (controller.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text(
                  controller.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            if (isRequired && !controller.isValidated)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text('* Required'.tr,
                  style: TextStyle(
                      color: textColor.withValues(alpha: 0.7), fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file,
          size: 50,
          color: iconColor,
        ),
        const SizedBox(height: 12),
        Text('Select an image or video'.tr,
          style: TextStyle(color: textColor),
        ),
        if (isRequired)
          Text('(Required)'.tr,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
      ],
    );
  }
}

class _FilePreview extends StatefulWidget {
  final FilePickerController controller;
  final BorderRadius borderRadius;
  final bool viewOnly;

  const _FilePreview({
    Key? key,
    required this.controller,
    required this.borderRadius,
    required this.viewOnly,
  }) : super(key: key);

  @override
  State<_FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<_FilePreview> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  @override
  void didUpdateWidget(covariant _FilePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.isVideo &&
        widget.controller.pickedFile != null &&
        (_videoController == null ||
            _videoController!.dataSource !=
                widget.controller.pickedFile!.path)) {
      _initializeVideoController();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideoController() {
    if (widget.controller.isVideo && widget.controller.pickedFile != null) {
      _videoController?.dispose();
      _videoController =
          VideoPlayerController.file(widget.controller.pickedFile!)
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
    } else if (widget.controller.isVideo && widget.controller.hasNetworkFile) {
      _videoController?.dispose();

      _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.controller.networkFile.toString()))
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.controller.isVideo)
          _buildVideoPreview()
        else
          _buildImagePreview(),
        if (!widget.viewOnly)
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => widget.controller.pickFile(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => widget.controller.clearFile(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: widget.borderRadius
          .subtract(const BorderRadius.all(Radius.circular(8))),
      child: widget.controller.hasNetworkFile
          ? CachedNetworkImage(
              imageUrl: widget.controller.networkFile!,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                  Text('Content not found'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
              width: double.infinity,
              height: double.infinity,
            )
          : Image.file(
              widget.controller.pickedFile!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: widget.borderRadius
              .subtract(const BorderRadius.all(Radius.circular(8))),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        IconButton(
          icon: Icon(
            _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 50,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _videoController!.value.isPlaying
                  ? _videoController!.pause()
                  : _videoController!.play();
            });
          },
        ),
      ],
    );
  }
}
