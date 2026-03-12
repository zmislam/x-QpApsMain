extension StringPathExtension on String {
  String get fileExtension => isEmpty ? this : split('.').last;

  bool get isVideo {
    final extension = fileExtension;
    return ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv'].contains(extension);
  }
}
