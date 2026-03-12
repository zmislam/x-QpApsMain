class PageReportModel {
  PageReportModel({
    this.id,
    this.reportType,
    this.description,
    this.createdBy,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? reportType;
  String? description;
  dynamic createdBy;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PageReportModel copyWith({
    String? id,
    String? reportType,
    String? description,
    dynamic createdBy,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PageReportModel(
      id: id ?? this.id,
      reportType: reportType ?? this.reportType,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory PageReportModel.fromMap(Map<String, dynamic> json) {
    return PageReportModel(
      id: json['_id'],
      reportType: json['report_type'],
      description: json['description'],
      createdBy: json['created_by'],
      date: DateTime.tryParse(json['date'] ?? ''),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  @override
  String toString() {
    return '$id, $reportType, $description, $createdBy, $date, $createdAt, $updatedAt, $v, ';
  }
}
