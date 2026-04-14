/// Anti-Abuse & Risk Models — Phase 5
/// All risk thresholds from EarningConfigService.antiAbuse — NEVER hardcoded.

class AccountStanding {
  final double riskScore; // 0-100
  final String riskLevel; // from API: 'low', 'medium', 'high', 'critical'
  final bool earningsFrozen;
  final double? frozenAmount;
  final String? warningMessage;
  final List<RiskFlag> flags;
  final DateTime? lastScanAt;
  final AppealInfo? activeAppeal;

  AccountStanding({
    required this.riskScore,
    required this.riskLevel,
    this.earningsFrozen = false,
    this.frozenAmount,
    this.warningMessage,
    this.flags = const [],
    this.lastScanAt,
    this.activeAppeal,
  });

  factory AccountStanding.fromJson(Map<String, dynamic> json) =>
      AccountStanding(
        riskScore: (json['riskScore'] ?? 0).toDouble(),
        riskLevel: json['riskLevel']?.toString() ?? 'low',
        earningsFrozen: json['earningsFrozen'] == true,
        frozenAmount: json['frozenAmount'] != null
            ? (json['frozenAmount']).toDouble()
            : null,
        warningMessage: json['warningMessage']?.toString(),
        flags: (json['flags'] as List?)
                ?.map((e) => RiskFlag.fromJson(e))
                .toList() ??
            [],
        lastScanAt: json['lastScanAt'] != null
            ? DateTime.tryParse(json['lastScanAt'].toString())
            : null,
        activeAppeal: json['activeAppeal'] != null
            ? AppealInfo.fromJson(json['activeAppeal'])
            : null,
      );

  bool get hasWarning =>
      riskLevel == 'medium' || riskLevel == 'high' || riskLevel == 'critical';
}

class RiskFlag {
  final String type; // e.g. 'duplicate_content', 'suspicious_activity', 'fake_engagement'
  final String description;
  final String severity; // 'low', 'medium', 'high'
  final DateTime? detectedAt;

  RiskFlag({
    required this.type,
    required this.description,
    required this.severity,
    this.detectedAt,
  });

  factory RiskFlag.fromJson(Map<String, dynamic> json) => RiskFlag(
        type: json['type']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        severity: json['severity']?.toString() ?? 'low',
        detectedAt: json['detectedAt'] != null
            ? DateTime.tryParse(json['detectedAt'].toString())
            : null,
      );
}

class AppealInfo {
  final String id;
  final String status; // 'pending', 'under_review', 'approved', 'rejected'
  final String reason;
  final String? explanation;
  final DateTime submittedAt;
  final DateTime? resolvedAt;
  final String? resolutionNote;

  AppealInfo({
    required this.id,
    required this.status,
    required this.reason,
    this.explanation,
    required this.submittedAt,
    this.resolvedAt,
    this.resolutionNote,
  });

  factory AppealInfo.fromJson(Map<String, dynamic> json) => AppealInfo(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        status: json['status']?.toString() ?? 'pending',
        reason: json['reason']?.toString() ?? '',
        explanation: json['explanation']?.toString(),
        submittedAt:
            DateTime.tryParse(json['submittedAt']?.toString() ?? '') ??
                DateTime.now(),
        resolvedAt: json['resolvedAt'] != null
            ? DateTime.tryParse(json['resolvedAt'].toString())
            : null,
        resolutionNote: json['resolutionNote']?.toString(),
      );
}

class DuplicateCheckResult {
  final bool isDuplicate;
  final double similarityScore;
  final String? matchedPostId;
  final String? warningMessage;

  DuplicateCheckResult({
    this.isDuplicate = false,
    this.similarityScore = 0,
    this.matchedPostId,
    this.warningMessage,
  });

  factory DuplicateCheckResult.fromJson(Map<String, dynamic> json) =>
      DuplicateCheckResult(
        isDuplicate: json['isDuplicate'] == true,
        similarityScore: (json['similarityScore'] ?? 0).toDouble(),
        matchedPostId: json['matchedPostId']?.toString(),
        warningMessage: json['warningMessage']?.toString(),
      );
}
