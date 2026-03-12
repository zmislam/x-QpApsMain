import 'dart:convert';

class TurnOnEarningDashboard {
  int? status;
  String? message;

  TurnOnEarningDashboard({
    this.status,
    this.message,
  });

  TurnOnEarningDashboard copyWith({
    int? status,
    String? message,
  }) =>
      TurnOnEarningDashboard(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory TurnOnEarningDashboard.fromRawJson(String str) => TurnOnEarningDashboard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TurnOnEarningDashboard.fromJson(Map<String, dynamic> json) => TurnOnEarningDashboard(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
