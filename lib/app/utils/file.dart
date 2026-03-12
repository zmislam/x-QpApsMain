import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

MediaType getMediaTypeFromFile(File file) {
  String fileExtension = file.path.split('.').last.toLowerCase();

  switch (fileExtension) {
    case 'pdf':
      return MediaType.parse('application/pdf');
    case 'jpeg':
    case 'jpg':
      return MediaType.parse('image/jpeg');
    case 'png':
      return MediaType.parse('image/png');
    case 'gif':
      return MediaType.parse('image/gif');
    case 'bmp':
      return MediaType.parse('image/bmp');
    case 'webp':
      return MediaType.parse('image/webp');
    case 'svg':
      return MediaType.parse('image/svg+xml');
    case 'txt':
      return MediaType.parse('text/plain');
    case 'html':
      return MediaType.parse('text/html');
    case 'css':
      return MediaType.parse('text/css');
    case 'js':
      return MediaType.parse('application/javascript');
    case 'json':
      return MediaType.parse('application/json');
    case 'xml':
      return MediaType.parse('application/xml');
    case 'zip':
      return MediaType.parse('application/zip');
    case 'rar':
      return MediaType.parse('application/vnd.rar');
    case '7z':
      return MediaType.parse('application/x-7z-compressed');
    case 'mp3':
      return MediaType.parse('audio/mpeg');
    case 'wav':
      return MediaType.parse('audio/wav');
    case 'ogg':
      return MediaType.parse('audio/ogg');
    case 'mp4':
      return MediaType.parse('video/mp4');
    case 'mkv':
      return MediaType.parse('video/x-matroska');
    case 'avi':
      return MediaType.parse('video/x-msvideo');
    case 'mov':
      return MediaType.parse('video/quicktime');
    case 'flv':
      return MediaType.parse('video/x-flv');
    default:
      return MediaType.parse('application/octet-stream'); // Default binary type
  }
}

String getFileNameFromFile(File file) {
  return file.path.split('/').last;
}

List<String> allowedFileExtensions = [
  'jpg',
  'jpeg',
  'jfif',
  'pjpeg',
  'pjp',
  'gif',
  'png',
  'svg',
  'bmp',
  'ogg',
  'webm',
  'mp4',
  'avi',
  'mov',
  'wmv',
  'mkv',
];
String getFileIconAsset(String? fileName) {
  if (fileName == null || fileName.isEmpty) {
    return 'assets/icon/group_file_icons/doc.png'; // Default icon
  }

  String extension = fileName.split('.').last.toLowerCase();

  switch (extension) {
    case 'pdf':
      return 'assets/icon/group_file_icons/pdf.png';
    case 'zip':
      return 'assets/icon/group_file_icons/rar.png';
    case 'xlsx':
    case 'xls':
      return 'assets/icon/group_file_icons/xls.png';
    case 'doc':
    case 'docx':
      return 'assets/icon/group_file_icons/doc.png';
    case 'ppt':
    case 'pptx':
      return 'assets/icons/ppt_icon.png';
    case 'jpg':
    case 'jpeg':
    case 'png':
      return 'assets/icons/image_icon.png';
    default:
      return 'assets/icon/group_file_icons/doc.png'; // Default icon for unknown extensions
  }
}

Future<List<PlatformFile>?> pickMultiFiles(
    {List<String>? allowedExtensions}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: allowedExtensions != null ? FileType.custom : FileType.any,
    allowedExtensions: allowedExtensions, // If null, allow any type
  );

  if (result != null) {
    return result.files; // Return the selected files
  }
  return null; // Return null if the user cancels the picker
}
