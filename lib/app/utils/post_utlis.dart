import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import '../extension/date_time_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/constants/app_assets.dart';
import '../data/login_creadential.dart';
import '../models/post.dart';
import '../models/user.dart';

/// Applies an optimistic reaction update on a PostModel.
///
/// Handles: toggle-off (same reaction), type change, and new reaction.
/// Works correctly even when [reactionTypeCountsByPost] is empty (API
/// optimization) by falling back to [reactionSummary.userReaction].
///
/// Mutates [post] in place and returns it for convenience.
PostModel applyOptimisticReaction({
  required PostModel post,
  required String userId,
  required String reactionType,
  Map<String, dynamic>? userDetails,
}) {
  final list = post.reactionTypeCountsByPost ?? [];
  post.reactionTypeCountsByPost = list;

  // 1. Find existing reaction: check list first, then reactionSummary
  String? prevType;
  int existingIdx = -1;
  for (int i = 0; i < list.length; i++) {
    if (list[i].user_id == userId) {
      existingIdx = i;
      prevType = list[i].reaction_type;
      break;
    }
  }
  if (prevType == null) {
    final ur = post.reactionSummary?['userReaction'];
    if (ur is Map && ur['hasReacted'] == true) {
      prevType = ur['type'] as String?;
    }
  }

  final isToggleOff = prevType == reactionType;

  // 2. Update the local list
  if (existingIdx != -1) {
    list.removeAt(existingIdx);
  }
  if (!isToggleOff) {
    list.add(ReactionModel.fromMap({
      'count': 1,
      'post_id': post.id,
      'reaction_type': reactionType,
      'user_id': userId,
    }));
  }

  // 3. Update count: DON'T use list.length (list may be partial/empty from API)
  final currentCount = post.reactionCount ?? 0;
  if (isToggleOff) {
    post.reactionCount = math.max(0, currentCount - 1);
  } else if (prevType != null) {
    // Changing type — count stays same
    post.reactionCount = currentCount;
  } else {
    // New reaction
    post.reactionCount = currentCount + 1;
  }

  // 4. Update reactionSummary so downstream reads stay accurate
  final breakdown = Map<String, dynamic>.from(
    post.reactionSummary?['breakdown'] ?? {},
  );
  // Decrement old type
  if (prevType != null && breakdown.containsKey(prevType)) {
    final oldCount = (breakdown[prevType] as int? ?? 1) - 1;
    if (oldCount <= 0) {
      breakdown.remove(prevType);
    } else {
      breakdown[prevType] = oldCount;
    }
  }
  // Increment new type (if not toggle-off)
  if (!isToggleOff) {
    breakdown[reactionType] = ((breakdown[reactionType] as int?) ?? 0) + 1;
  }
  post.reactionSummary = {
    ...(post.reactionSummary ?? {}),
    'userReaction': isToggleOff
        ? {'hasReacted': false, 'type': null}
        : {'hasReacted': true, 'type': reactionType},
    'breakdown': breakdown,
  };

  return post;
}

/// Returns the user's current reaction type from a PostModel.
/// Checks [reactionTypeCountsByPost] first, then falls back to
/// [reactionSummary.userReaction].
String? getUserReactionType(PostModel postModel, String userId) {
  for (final r in postModel.reactionTypeCountsByPost ?? []) {
    if (r.user_id == userId) {
      return r.reaction_type;
    }
  }
  final ur = postModel.reactionSummary?['userReaction'];
  if (ur is Map && ur['hasReacted'] == true) {
    return ur['type'] as String?;
  }
  return null;
}

/// Returns the list of distinct reaction type asset paths for display.
/// Checks [reactionTypeCountsByPost] first (backward compat), then falls
/// back to [reactionSummary.breakdown].
List<String> getReactionAssets(PostModel postModel, {int maxCount = 3}) {
  final List<String> assets = [];
  final list = postModel.reactionTypeCountsByPost ?? [];

  if (list.isNotEmpty) {
    for (final reaction in list) {
      final asset = _typeToAsset(reaction.reaction_type ?? '');
      if (asset != null && !assets.contains(asset)) {
        assets.add(asset);
      }
      if (assets.length >= maxCount) break;
    }
  } else {
    // Fallback: derive from reactionSummary.breakdown
    final breakdown = postModel.reactionSummary?['breakdown'];
    if (breakdown is Map) {
      for (final type in breakdown.keys) {
        final count = breakdown[type];
        if (count is int && count > 0) {
          final asset = _typeToAsset(type.toString());
          if (asset != null && !assets.contains(asset)) {
            assets.add(asset);
          }
          if (assets.length >= maxCount) break;
        }
      }
    }
  }
  return assets;
}

String? _typeToAsset(String type) {
  switch (type) {
    case 'like':
      return AppAssets.LIKE_ICON;
    case 'love':
      return AppAssets.LOVE_ICON;
    case 'haha':
      return AppAssets.HAHA_ICON;
    case 'wow':
      return AppAssets.WOW_ICON;
    case 'sad':
      return AppAssets.SAD_ICON;
    case 'angry':
      return AppAssets.ANGRY_ICON;
    case 'dislike':
      return AppAssets.UNLIKE_ICON;
    default:
      return null;
  }
}

String getReactionIconPath(String reactionType) {
  switch (reactionType) {
    case 'like':
      return AppAssets.LIKE_ICON;
    case 'love':
      return AppAssets.LOVE_ICON;
    case 'haha':
      return AppAssets.HAHA_ICON;
    case 'wow':
      return AppAssets.WOW_ICON;
    case 'sad':
      return AppAssets.SAD_ICON;
    case 'angry':
      return AppAssets.ANGRY_ICON;
    case 'dislike':
      return AppAssets.UNLIKE_ICON;
    default:
      return AppAssets.LIKE_ICON;
  }
}

String getDynamicFormatedTime(String time) {
  if (time.isEmpty) return 'Unknown';

  try {
    DateTime postDateTime = DateTime.parse(time).toLocal();
    DateTime currentDatetime = DateTime.now();

    int millisecondsDifference = currentDatetime.millisecondsSinceEpoch -
        postDateTime.millisecondsSinceEpoch;
    int minutesDifference =
        (millisecondsDifference / Duration.millisecondsPerMinute).truncate();

    if (minutesDifference < 1) {
      return 'Just now';
    } else if (minutesDifference < 30) {
      return '$minutesDifference minutes ago';
    } else if (DateUtils.isSameDay(postDateTime, currentDatetime)) {
      return 'Today at ${postTimeFormat.format(postDateTime)}';
    } else {
      return postDateTimeFormat.format(postDateTime);
    }
  } catch (e) {
    return 'Invalid date';
  }
}

String getDynamicFormatedCommentTime(String time) {
  DateTime postDateTime = DateTime.parse(time).toLocal();
  DateTime currentDatetime = DateTime.now();
  // Calculate the difference in milliseconds
  int millisecondsDifference = currentDatetime.millisecondsSinceEpoch -
      postDateTime.millisecondsSinceEpoch;
  // Convert to minutes (ignoring milliseconds)
  int minutesDifference =
      (millisecondsDifference / Duration.millisecondsPerMinute).truncate();

  if (minutesDifference <= 1) {
    return 'Just now'.tr;
  } else if (minutesDifference <= 60) {
    return '$minutesDifference min';
  } else if (minutesDifference > 60 && minutesDifference < 120) {
    // Less than 1 day
    return '1 h';
  } else if (minutesDifference < 60 * 24) {
    // Less than 1 day
    final hours = (minutesDifference / 60).floor();
    return '$hours h';
  } else if (minutesDifference < 60 * 48) {
    return '1 day ago';
  } else if (minutesDifference < 60 * 24 * 7) {
    final days = (minutesDifference / 1440).floor();
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (minutesDifference < 60 * 24 * 30) {
    final weeks = (minutesDifference / 10080).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} ago';
  } else if (minutesDifference < 60 * 24 * 365) {
    final months = (minutesDifference / 43200).floor(); // Approx 30 days
    return '$months month${months > 1 ? 's' : ''} ago';
  } else {
    final years = (minutesDifference / 525600).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  }
}

List<TextSpan> getTextWithLink(String text) {
  List<String> textList = text.split(' ');
  List<TextSpan> textWithLink = [];
  for (String splitText in textList) {
    if (splitText.startsWith('http')) {
      textWithLink.add(
        TextSpan(
          text: splitText,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      textWithLink.add(
        TextSpan(
          text: splitText,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      );
    }
  }
  return textWithLink;
}

class LinkText extends StatefulWidget {
  final String text;
  final int collapsedLines;

  const LinkText({
    super.key,
    required this.text,
    this.collapsedLines = 2,
  });

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final linkRegExp = RegExp(r'(https?://[^\s]+)', caseSensitive: false);
    final matches = linkRegExp.allMatches(widget.text);
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start != lastEnd) {
        spans.add(TextSpan(
          text: widget.text.substring(lastEnd, match.start),
          style: Theme.of(context).textTheme.bodySmall,
        ));
      }
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          },
      ));
      lastEnd = match.end;
    }

    if (lastEnd != widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(lastEnd),
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: _expanded ? null : widget.collapsedLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          text: TextSpan(children: spans),
        ),
        if (_needsToggle(spans))
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'See less' : 'See more',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _needsToggle(List<TextSpan> spans) {
    // Simple heuristic: only show toggle if text is longer than collapsedLines.
    // You can refine with a TextPainter measure if needed.
    return widget.text.length > 80; // tweak as appropriate
  }
}

Reaction<String>? getSelectedReaction(PostModel postModel) {
  LoginCredential credential = LoginCredential();
  UserModel userModel = credential.getUserData();

  // Check reactionTypeCountsByPost first
  if (postModel.reactionTypeCountsByPost != null) {
    for (ReactionModel reactionModel in postModel.reactionTypeCountsByPost!) {
      if (reactionModel.user_id == userModel.id) {
        return Reaction<String>(
          value: reactionModel.reaction_type,
          icon: Row(
            children: [
              ReactionIcon(
                  getReactionIconPath(reactionModel.reaction_type ?? '')),
              const SizedBox(width: 10),
              Text(reactionModel.reaction_type?.capitalizeFirst ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ))
            ],
          ),
        );
      }
    }
  }

  // Fallback: check reactionSummary.userReaction
  final ur = postModel.reactionSummary?['userReaction'];
  if (ur is Map && ur['hasReacted'] == true && ur['type'] != null) {
    final type = ur['type'] as String;
    return Reaction<String>(
      value: type,
      icon: Row(
        children: [
          ReactionIcon(getReactionIconPath(type)),
          const SizedBox(width: 10),
          Text(type.capitalizeFirst ?? '',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ))
        ],
      ),
    );
  }

  return Reaction<String>(
    value: 'like',
    icon: Row(
      children: [
        ReactionIcon(AppAssets.LIKE_ACTION_ICON),
        const SizedBox(width: 10),
        Text('Like'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ))
      ],
    ),
  );
}

Widget ReactionIcon(String assetName, {double? height = 32}) {
  return Image(height: height ?? 32, image: AssetImage(assetName));
}

String getPostPrivacyValue(String titile) {
  switch (titile) {
    case 'Public':
      return 'public';
    case 'Friends':
      return 'friends';
    case 'Only Me':
      return 'only_me';
    default:
      return 'public';
  }
}

String getReelsPostPrivacyValue(String titile) {
  switch (titile) {
    case 'Public':
      return 'public';
    case 'Friends':
      return 'friends';
    case 'Only Me':
      return 'only_me';
    default:
      return 'public';
  }
}
