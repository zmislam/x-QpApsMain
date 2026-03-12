import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../modules/shared/modules/create_post/models/imageCheckerModel.dart';
import '../../modules/shared/modules/create_post/service/imageCheckerService.dart';

class FilePickerController extends ChangeNotifier {
  File? pickedFile;
  bool isVideo = false;
  String? errorMessage;
  bool isValidated = false;
  String? networkFile;

  String checkingStatus = '';
  bool isCheckingFiles = false;
  List<String> processedFileData = <String>[];
  String processedCommentFileData = '';
  List<FileCheckingState> fileCheckingStates = <FileCheckingState>[];
  List<XFile> acceptedFiles = <XFile>[];

  final void Function(List<String> removedFiles)? onRemovedFiles;

  FilePickerController({this.onRemovedFiles});

  bool get hasFile => pickedFile != null;
  bool get hasNetworkFile => networkFile != null;

  final videoExtensions = [
    'mp4',
    'mov',
    'avi',
    'wmv',
    'flv',
    'mkv',
    'webm',
    'm4v',
    '3gp'
  ];

  void setNetworkFile({required String fileUrl}) {
    networkFile = fileUrl;
    isVideo = videoExtensions.contains(fileUrl.split('.').last.toLowerCase());
    notifyListeners();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg','jpeg','png','gif','bmp','webp','heic','heif',
        'mp4','mov','avi','wmv','flv','mkv','webm','m4v','3gp'
      ],
    );

    if (result == null) return;

    final path = result.files.single.path;
    networkFile = null;

    if (path == null) {
      errorMessage = 'Selected file path is not available.';
      notifyListeners();
      return;
    }

    pickedFile = File(path);
    final extension = path.toLowerCase().split('.').last;
    isVideo = videoExtensions.contains(extension);
    errorMessage = null;
    notifyListeners();

    try {
      final XFile xfile = XFile(path);
      await checkFilesForVulgarity(<XFile>[xfile]);
    } catch (e, st) {
      debugPrint('Error checking file: $e\n$st');
      errorMessage = 'Error checking file content.';
      clearFile();
      notifyListeners();
    }
  }

  Future<void> checkFilesForVulgarity(List<XFile> newFiles) async {
    debugPrint('Running file vulgarity check for ${newFiles.length} file(s)');

    isCheckingFiles = true;
    checkingStatus = 'Checking files for inappropriate content...';
    processedFileData.clear();
    processedCommentFileData = '';
    acceptedFiles.clear();

    fileCheckingStates = newFiles
        .map((file) => FileCheckingState(
      fileName: file.name,
      filePath: file.path,
      isChecking: true,
    ))
        .toList();

    notifyListeners();

    List<String> removedFiles = [];

    for (int i = 0; i < newFiles.length; i++) {
      final XFile file = newFiles[i];
      final String filePath = file.path.toLowerCase();

      try {
        checkingStatus = 'Checking ${i + 1}/${newFiles.length}: ${file.name}';
        fileCheckingStates[i].isChecking = true;
        notifyListeners();

        ImageCheckerModel? checkerResponse;

        if (filePath.endsWithAny([
          '.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.heic', '.heif'
        ])) {
          checkerResponse = await ImageCheckerService.checkImageForVulgarity(file);
        } else if (filePath.endsWithAny([
          '.mp4', '.mov', '.avi', '.mkv', '.flv', '.wmv', '.webm', '.m4v', '.3gp'
        ])) {
          checkerResponse = await ImageCheckerService.checkVideoForVulgarity(file);
        } else {
          removedFiles.add(file.name);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isFailed = true;
          notifyListeners();
          continue;
        }

        if (checkerResponse == null) {
          removedFiles.add(file.name);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isFailed = true;
          notifyListeners();
          continue;
        }

        if (checkerResponse.sexual == true) {
          removedFiles.add(file.name);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isFailed = true;
          notifyListeners();
          if (pickedFile != null && pickedFile!.path == file.path) clearFile();
        } else {
          acceptedFiles.add(file);
          if (checkerResponse.data != null) {
            processedFileData.add(checkerResponse.data!);
            processedCommentFileData = checkerResponse.data!;
          }
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isPassed = true;
          notifyListeners();
        }
      } catch (e, st) {
        debugPrint('Error checking ${file.name}: $e\n$st');
        removedFiles.add(file.name);
        fileCheckingStates[i].isChecking = false;
        fileCheckingStates[i].isFailed = true;
        notifyListeners();
        if (pickedFile != null && pickedFile!.path == file.path) clearFile();
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (removedFiles.isNotEmpty) {
      if (onRemovedFiles != null) {
        onRemovedFiles!(removedFiles);
      } else {
        String message = removedFiles.length == 1
            ? '${removedFiles.first} was removed due to inappropriate content'
            : '${removedFiles.length} files were removed due to inappropriate content';
        try {
          Get.snackbar(
            'Content Removed',
            message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(10),
          );
        } catch (_) {}
      }
    }

    await Future.delayed(const Duration(milliseconds: 800));
    fileCheckingStates.clear();

    isCheckingFiles = false;
    checkingStatus = '';
    notifyListeners();
  }

  void clearProcessedData() {
    processedFileData.clear();
    processedCommentFileData = '';
    notifyListeners();
  }

  void hideErrorMessage() {
    errorMessage = null;
    notifyListeners();
  }

  void clearFile() {
    pickedFile = null;
    isVideo = false;
    errorMessage = null;
    networkFile = null;
    notifyListeners();
  }

  bool validate({bool required = false}) {
    isValidated = true;
    if (required && pickedFile == null) {
      errorMessage = 'Please select a file';
      notifyListeners();
      return false;
    }
    errorMessage = null;
    notifyListeners();
    return true;
  }

  void resetValidation() {
    isValidated = false;
    errorMessage = null;
    notifyListeners();
  }
}

class FileCheckingState {
  final String fileName;
  final String filePath;
  bool isChecking;
  bool isPassed;
  bool isFailed;

  FileCheckingState({
    required this.fileName,
    required this.filePath,
    this.isChecking = false,
    this.isPassed = false,
    this.isFailed = false,
  });
}

extension StringEndsWithAny on String {
  bool endsWithAny(List<String> suffixes) {
    final lower = toLowerCase();
    for (final s in suffixes) {
      if (lower.endsWith(s.toLowerCase())) return true;
    }
    return false;
  }
}
