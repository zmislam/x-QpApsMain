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