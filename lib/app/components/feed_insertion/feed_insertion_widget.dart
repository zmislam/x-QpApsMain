import 'package:flutter/material.dart';
import '../../config/constants/feed_design_tokens.dart';
import '../../models/feed_insertion_model.dart';
import '../../models/sponsored_ad_model.dart';
import '../../repository/edgerank_repository.dart';
import 'friend_suggestion_card.dart';
import 'group_suggestion_card.dart';
import 'page_suggestion_card.dart';
import 'reel_suggestion_card.dart';
import '../sponsored_ad/sponsored_ad_widget.dart';
import 'sponsored_post_card.dart';
import 'story_suggestion_card.dart';

/// Maps insertion type to the API endpoint type parameter.
const _typeToApiParam = {
  'friend_suggestion': 'friends',
  'group_suggestion': 'groups',
  'page_suggestion': 'pages',
  'story_suggestion': 'stories',
  'reel_suggestion': 'reels',
};

/// Router widget that renders the correct insertion widget based on [FeedInsertionModel.type].
///
/// For organic types (friend / group / page / story / reel) the backend sends
/// `data: null`.  This widget lazy-loads the suggestion payload from
/// `GET /api/feed/insertion-suggestions/:type` the first time it is built and
/// caches the result for the widget's lifetime.
class FeedInsertionWidget extends StatefulWidget {
  const FeedInsertionWidget({super.key, required this.insertion});

  final FeedInsertionModel insertion;

  @override
  State<FeedInsertionWidget> createState() => _FeedInsertionWidgetState();
}

class _FeedInsertionWidgetState extends State<FeedInsertionWidget> {
  final EdgeRankRepository _repo = EdgeRankRepository();

  /// The resolved data map that will be passed to the card widget.
  Map<String, dynamic>? _resolvedData;

  /// Whether we are currently fetching lazy-load data.
  bool _isLoading = false;

  /// Whether the fetch already failed (avoid infinite retries).
  bool _fetchFailed = false;

  @override
  void initState() {
    super.initState();
    _resolveData();
  }

  /// If the insertion already carries data (e.g. sponsored), use it directly.
  /// Otherwise, fetch suggestions from the lazy-load endpoint.
  Future<void> _resolveData() async {
    if (widget.insertion.data != null &&
        widget.insertion.data!.isNotEmpty) {
      // Data already available (sponsored posts or pre-filled insertions)
      _resolvedData = widget.insertion.data;
      return;
    }

    // Determine the API type parameter for this insertion
    final apiType = _typeToApiParam[widget.insertion.type];
    if (apiType == null) return; // unknown type — nothing to load

    setState(() => _isLoading = true);

    try {
      final response = await _repo.getInsertionSuggestions(
        type: apiType,
        limit: apiType == 'stories' ? 6 : (apiType == 'reels' ? 3 : 5),
      );

      if (!mounted) return;

      if (response.isSuccessful && response.data != null) {
        final responseData = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        // The API returns { status, suggestions: [...] }
        final suggestions = responseData['suggestions'] ?? [];

        setState(() {
          _resolvedData = {'suggestions': suggestions};
          _isLoading = false;
        });
      } else {
        debugPrint(
            '[FeedInsertion] Failed to lazy-load ${widget.insertion.type}: ${response.message}');
        setState(() {
          _isLoading = false;
          _fetchFailed = true;
        });
      }
    } catch (e) {
      debugPrint('[FeedInsertion] Error lazy-loading ${widget.insertion.type}: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _fetchFailed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Still loading — show a compact shimmer placeholder
    if (_isLoading) {
      return _buildLoadingPlaceholder(context);
    }

    // Failed or no data — hide entirely
    if (_fetchFailed || _resolvedData == null) {
      return const SizedBox.shrink();
    }

    final data = _resolvedData!;

    switch (widget.insertion.type) {
      case 'sponsored':
        final adModel = SponsoredAdModel(
          position: widget.insertion.position,
          type: widget.insertion.type,
          data: data,
          isBoostedPagePost: data['is_boosted_page_post'] == true,
          anchorPostId: widget.insertion.anchorPostId,
        );

        // Keep a legacy fallback for malformed payloads.
        final adId = adModel.adId;
        if (adId == null || adId.trim().isEmpty) {
          return SponsoredPostCard(data: data);
        }

        return SponsoredAdWidget(ad: adModel);
      case 'friend_suggestion':
        return FriendSuggestionCard(data: data);
      case 'group_suggestion':
        return GroupSuggestionCard(data: data);
      case 'page_suggestion':
        return PageSuggestionCard(data: data);
      case 'story_suggestion':
        return StorySuggestionCard(data: data);
      case 'reel_suggestion':
        return ReelSuggestionCard(data: data);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Small shimmer placeholder shown while lazy-loading organic suggestions.
  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: FeedDesignTokens.separatorHeight,
            color: FeedDesignTokens.surfaceBg(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FeedDesignTokens.cardPaddingH,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: FeedDesignTokens.cardPaddingH,
              ),
              itemCount: 3,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
