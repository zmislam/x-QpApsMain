class Deletemodel {
  Deletemodel({
    required this.acknowledged,
    required this.deletedCount,
  });

  final bool? acknowledged;
  final int? deletedCount;

  Deletemodel copyWith({
    bool? acknowledged,
    int? deletedCount,
  }) {
    return Deletemodel(
      acknowledged: acknowledged ?? this.acknowledged,
      deletedCount: deletedCount ?? this.deletedCount,
    );
  }

  factory Deletemodel.fromMap(Map<String, dynamic> json) {
    return Deletemodel(
      acknowledged: json['acknowledged'],
      deletedCount: json['deletedCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'acknowledged': acknowledged,
        'deletedCount': deletedCount,
      };

  @override
  String toString() {
    return '$acknowledged, $deletedCount, ';
  }
}
