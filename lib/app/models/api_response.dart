// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiResponse {
  bool isSuccessful;
  int? statusCode;
  String? message;
  Object? data;
  int? pageCount;
  ApiResponse({
    required this.isSuccessful,
    this.statusCode,
    this.message,
    this.data,
    this.pageCount,
  });

  @override
  String toString() {
    return 'ApiResponse(isSuccessful: $isSuccessful, statusCode: $statusCode, message: $message, data: $data)';
  }

  ApiResponse copyWith({
    bool? isSuccessful,
    int? statusCode,
    String? message,
    Object? data,
    int? pageCount,
  }) {
    return ApiResponse(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}
