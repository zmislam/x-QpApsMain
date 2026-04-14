import '../../../config/api/api_communication.dart';
import '../models/viral_content_models.dart';

class ViralApiService {
  /// GET /api/viral/trending — List trending posts
  Future<List<TrendingPost>> fetchTrending({String sortBy = 'score'}) async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'viral/trending?sortBy=$sortBy',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is List) {
      return (response.data as List)
          .map((e) => TrendingPost.fromJson(e))
          .toList();
    }
    return [];
  }

  /// GET /api/viral/my-posts — User's viral content list
  Future<MyViralPostsResponse> fetchMyViralPosts() async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'viral/my-posts',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return MyViralPostsResponse.fromJson(
          Map<String, dynamic>.from(response.data));
    }
    return MyViralPostsResponse();
  }

  /// GET /api/viral/post/:id — Viral status for specific post
  Future<ViralPostInfo?> fetchPostViralStatus(String postId) async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'viral/post/$postId',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return ViralPostInfo.fromJson(
          Map<String, dynamic>.from(response.data));
    }
    return null;
  }

  /// GET /api/viral/score/:id — Detailed viral score breakdown
  Future<ViralScoreBreakdown?> fetchScoreBreakdown(String postId) async {
    final response = await ApiCommunication().doGetRequest(
      apiEndPoint: 'viral/score/$postId',
      responseDataKey: 'data',
    );
    if (response.isSuccessful && response.data is Map) {
      return ViralScoreBreakdown.fromJson(
          Map<String, dynamic>.from(response.data));
    }
    return null;
  }
}
