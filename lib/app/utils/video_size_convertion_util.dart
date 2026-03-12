import 'package:flutter/material.dart';

Size getScaledSize(Size videoSize, Size screenSize) {
  double videoAspectRatio = videoSize.width / videoSize.height;
  double screenAspectRatio = screenSize.width / screenSize.height;

  if (videoAspectRatio > screenAspectRatio) {
    // Fit to screen width
    double scaledHeight = screenSize.width / videoAspectRatio;
    return Size(screenSize.width, scaledHeight);
  } else {
    // Fit to screen height
    double scaledWidth = screenSize.height * videoAspectRatio;
    return Size(scaledWidth, screenSize.height);
  }
}


Size getScaledSizeEX(Size videoSize, Size screenSize) {
  // Calculate aspect ratios
  double videoAspectRatio = videoSize.width / videoSize.height;
  double screenAspectRatio = screenSize.width / screenSize.height;

  // Determine the scaling factor
  double scaleFactor;
  if (videoAspectRatio > screenAspectRatio) {
    // Video is wider than the screen, scale based on height
    scaleFactor = screenSize.height / videoSize.height;
  } else {
    // Video is taller than the screen, scale based on width
    scaleFactor = screenSize.width / videoSize.width;
  }

  // Calculate new video dimensions
  double newWidth = videoSize.width * scaleFactor;
  double newHeight = videoSize.height * scaleFactor;

  return Size(newWidth, newHeight);

}
