class StripePaymentResponse {
  final String? clientSecret;

  StripePaymentResponse({this.clientSecret});

  factory StripePaymentResponse.fromJson(Map<String, dynamic> json) {
    return StripePaymentResponse(
      clientSecret: json['clientSecret'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'clientSecret': clientSecret,
  };
}
