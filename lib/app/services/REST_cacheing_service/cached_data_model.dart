import 'package:dio/dio.dart';

class CachedDataModel {
  final dynamic responseBody; // Extract only serializable data
  final RequestOptions requestOptions;
  final int statusCode;
  final int ttl;

  CachedDataModel({
    required this.responseBody,
    required this.statusCode,
    required this.ttl,
    required this.requestOptions,
  });

  // Convert object to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'responseBody': responseBody, // Only store body, not the entire Response object
      'statusCode': statusCode,
      'requestOptions': requestOptionsToJson(requestOptions),
      'ttl': ttl,
    };
  }

  // Convert JSON back to CachedDataModel
  factory CachedDataModel.fromJson(Map<String, dynamic> json) {
    return CachedDataModel(
      responseBody: json['responseBody'],
      statusCode: json['statusCode'],
      requestOptions: requestOptionsFromJson(json['requestOptions']),
      ttl: json['ttl'],
    );
  }

  Map<String, dynamic> requestOptionsToJson(RequestOptions options) {
    return {
      'method': options.method,
      'path': options.path,
      'headers': options.headers,
      'queryParameters': options.queryParameters,
      'data': options.data,
      'contentType': options.contentType.toString(),
      'responseType': options.responseType.toString(),
      'followRedirects': options.followRedirects,
      'extra': options.extra,
    };
  }
}

RequestOptions requestOptionsFromJson(Map<String, dynamic> json) {
  return RequestOptions(
    method: json['method'],
    path: json['path'],
    headers: Map<String, dynamic>.from(json['headers'] ?? {}),
    queryParameters: Map<String, dynamic>.from(json['queryParameters'] ?? {}),
    data: json['data'],
    contentType: json['contentType'],
    responseType: ResponseType.values.firstWhere(
      (e) => e.toString() == 'ResponseType.${json['responseType']?.split('.')?.last}',
      orElse: () => ResponseType.json,
    ),
    followRedirects: json['followRedirects'] ?? true,
    extra: Map<String, dynamic>.from(json['extra'] ?? {}),
  );
}
