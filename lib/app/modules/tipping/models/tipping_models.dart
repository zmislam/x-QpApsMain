/// Tipping & Donations Models — Phase 6

class TipSummary {
  final double totalReceived;
  final double totalSent;
  final int supportersCount;
  final int tipsReceivedCount;
  final int tipsSentCount;
  final TopSupporter? topSupporter;

  TipSummary({
    this.totalReceived = 0,
    this.totalSent = 0,
    this.supportersCount = 0,
    this.tipsReceivedCount = 0,
    this.tipsSentCount = 0,
    this.topSupporter,
  });

  factory TipSummary.fromJson(Map<String, dynamic> json) => TipSummary(
        totalReceived: (json['totalReceived'] ?? 0).toDouble(),
        totalSent: (json['totalSent'] ?? 0).toDouble(),
        supportersCount: json['supportersCount'] ?? 0,
        tipsReceivedCount: json['tipsReceivedCount'] ?? 0,
        tipsSentCount: json['tipsSentCount'] ?? 0,
        topSupporter: json['topSupporter'] != null
            ? TopSupporter.fromJson(json['topSupporter'])
            : null,
      );
}

class TipTransaction {
  final String id;
  final String type; // 'sent' or 'received'
  final double amount;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserAvatar;
  final String toUserId;
  final String toUserName;
  final String? toUserAvatar;
  final String? message;
  final DateTime createdAt;
  final String? postId;

  TipTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserAvatar,
    required this.toUserId,
    required this.toUserName,
    this.toUserAvatar,
    this.message,
    required this.createdAt,
    this.postId,
  });

  factory TipTransaction.fromJson(Map<String, dynamic> json) =>
      TipTransaction(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        type: json['type']?.toString() ?? 'received',
        amount: (json['amount'] ?? 0).toDouble(),
        fromUserId: json['fromUserId']?.toString() ?? '',
        fromUserName: json['fromUserName']?.toString() ?? '',
        fromUserAvatar: json['fromUserAvatar']?.toString(),
        toUserId: json['toUserId']?.toString() ?? '',
        toUserName: json['toUserName']?.toString() ?? '',
        toUserAvatar: json['toUserAvatar']?.toString(),
        message: json['message']?.toString(),
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
                DateTime.now(),
        postId: json['postId']?.toString(),
      );
}

class TopSupporter {
  final String userId;
  final String userName;
  final String? avatar;
  final double totalAmount;
  final int tipCount;
  final String? badgeLevel; // e.g. 'bronze', 'silver', 'gold', 'diamond'

  TopSupporter({
    required this.userId,
    required this.userName,
    this.avatar,
    this.totalAmount = 0,
    this.tipCount = 0,
    this.badgeLevel,
  });

  factory TopSupporter.fromJson(Map<String, dynamic> json) => TopSupporter(
        userId: json['userId']?.toString() ?? '',
        userName: json['userName']?.toString() ?? '',
        avatar: json['avatar']?.toString(),
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        tipCount: json['tipCount'] ?? 0,
        badgeLevel: json['badgeLevel']?.toString(),
      );
}

class TipGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final bool isActive;

  TipGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0,
    this.deadline,
    this.isActive = true,
  });

  factory TipGoal.fromJson(Map<String, dynamic> json) => TipGoal(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        targetAmount: (json['targetAmount'] ?? 0).toDouble(),
        currentAmount: (json['currentAmount'] ?? 0).toDouble(),
        deadline: json['deadline'] != null
            ? DateTime.tryParse(json['deadline'].toString())
            : null,
        isActive: json['isActive'] != false,
      );

  double get progressPercent =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0, 1) : 0;
}
