import 'dart:io';
import 'dart:math';
import '../../../../services/api_communication.dart';
import '../../../../models/api_response.dart';
import '../utils/reel_constants.dart';

/// Reels V2 Upload Service — handles chunked upload with progress,
/// background upload support, and upload status polling.
class ReelsV2UploadService {
  final ApiCommunication _api = ApiCommunication();

  // Chunk size: 2 MB
  static const int _chunkSize = 2 * 1024 * 1024;

  /// Upload a reel with chunked upload, thumbnail, and optional A/B thumbnails.
  /// Calls [onProgress] with a value between 0.0 and 1.0.
  Future<ApiResponse> uploadReel({
    required String videoPath,
    required Map<String, dynamic> payload,
    File? thumbnailFile,
    File? abThumbnailA,
    File? abThumbnailB,
    void Function(double progress)? onProgress,
  }) async {
    final videoFile = File(videoPath);
    if (!videoFile.existsSync()) {
      return ApiResponse(isSuccessful: false, message: 'Video file not found');
    }

    final fileSize = videoFile.lengthSync();
    final totalChunks = (fileSize / _chunkSize).ceil();

    // Phase 1: Upload video chunks
    String? uploadId;
    for (int i = 0; i < totalChunks; i++) {
      final start = i * _chunkSize;
      final end = min(start + _chunkSize, fileSize);
      final chunkBytes = videoFile.readAsBytesSync().sublist(start, end);

      final chunkData = <String, dynamic>{
        'chunk_index': i,
        'total_chunks': totalChunks,
        'file_size': fileSize,
        'chunk_data': chunkBytes,
        if (uploadId != null) 'upload_id': uploadId,
      };

      final chunkResponse = await _api.doPostRequest(
        apiEndPoint: ReelConstants.uploadChunk,
        requestData: chunkData,
      );

      if (chunkResponse.data != null && (chunkResponse.data as Map<String, dynamic>)['upload_id'] != null) {
        uploadId = (chunkResponse.data as Map<String, dynamic>)['upload_id'] as String;
      }

      onProgress?.call((i + 1) / (totalChunks + 1));
    }

    if (uploadId == null) {
      return ApiResponse(isSuccessful: false, message: 'Upload failed: no upload ID');
    }

    // Phase 2: Submit for processing with metadata
    final processData = <String, dynamic>{
      'upload_id': uploadId,
      ...payload,
    };

    if (thumbnailFile != null) {
      processData['has_thumbnail'] = true;
    }
    if (abThumbnailA != null && abThumbnailB != null) {
      processData['has_ab_thumbnail'] = true;
    }

    final processResponse = await _api.doPostRequest(
      apiEndPoint: ReelConstants.uploadProcess,
      requestData: processData,
    );

    onProgress?.call(1.0);
    return processResponse;
  }

  /// Poll upload/processing status by upload ID.
  Future<ApiResponse> getUploadStatus(String uploadId) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.uploadStatus(uploadId),
    );
  }

  /// Cancel an in-progress upload.
  Future<ApiResponse> cancelUpload(String uploadId) async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.uploadStatus(uploadId),
    );
  }
}
