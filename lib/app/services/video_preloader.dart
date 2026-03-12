import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

class VideoPreloader {
  final CacheManager cacheManager;
  final Dio dio;

  VideoPreloader({CacheManager? cacheManager, Dio? dioInstance})
      : cacheManager = cacheManager ?? DefaultCacheManager(),
        dio = dioInstance ?? Dio();

  /// Returns a local File for the provided URL.
  /// Uses flutter_cache_manager; falls back to direct Dio download if needed.
  Future<File?> getCachedFile(String url, {CancelToken? cancelToken}) async {
    try {
      // 1) Try cache manager
      final fileInfo = await cacheManager.getFileFromCache(url);
      if (fileInfo != null && await fileInfo.file.exists()) {
        return fileInfo.file;
      }

      // 2) Not in cache -> download + store in cache
      final file = await cacheManager.getSingleFile(url);
      if (await file.exists()) {
        return file;
      }

      return null;
    } catch (e) {
      debugPrint('VideoPreloader: cache_manager download failed, trying Dio: $e');
      try {
        final tempDir = Directory.systemTemp;
        final filename = p.basename(Uri.parse(url).path);
        final target = File('${tempDir.path}/$filename');

        await dio.download(
          url,
          target.path,
          cancelToken: cancelToken,
          options: Options(receiveTimeout: Duration(milliseconds: 6000)),
        );

        if (await target.exists()) {
          return target;
        }
      } catch (e2) {
        debugPrint('VideoPreloader: dio fallback failed: $e2');
      }
    }
    return null;
  }

  /// Remove a specific cached file for `url`.
  Future<void> evict(String url) async {
    try {
      await cacheManager.removeFile(url);
    } catch (e) {
      debugPrint('VideoPreloader.evict failed for $url: $e');
    }
  }

  /// Evict multiple urls
  Future<void> evictAll(List<String> urls) async {
    for (final url in urls) {
      await evict(url);
    }
  }
}
