/// Represents a single feed insertion slot returned by the EdgeRank API.
///
/// Insertions are injected between posts in the newsfeed at specific positions.
/// Types include: sponsored, friend_suggestion, group_suggestion,
/// page_suggestion, story_suggestion, reel_suggestion.
class FeedInsertionModel {
  final int position;
  final String type;
  final Map<String, dynamic>? data;

  /// The post ID this insertion is anchored **after**.
  /// Computed client-side by matching `position` index to the posts list.
  String? anchorPostId;

  FeedInsertionModel({
    required this.position,
    required this.type,
    this.data,
    this.anchorPostId,
  });

  factory FeedInsertionModel.fromMap(Map<String, dynamic> map) {
    return FeedInsertionModel(
      position: map['position'] as int? ?? 0,
      type: map['type'] as String? ?? 'unknown',
      data: map['data'] != null
          ? Map<String, dynamic>.from(map['data'] as Map)
          : null,
    );
  }

  @override
  String toString() =>
      'FeedInsertionModel(position: $position, type: $type, hasData: ${data != null})';
}
