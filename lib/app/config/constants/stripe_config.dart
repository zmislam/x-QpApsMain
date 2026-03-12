import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfig {
  static Future<void> init() async {
    Stripe.publishableKey = 'pk_test_51RvjoJKLbPKxS0rkmhfNrNS89BSovjD8oIzculhqhRpPXN50bTv26yxjf5ExL5y90CTmpmDiONIB0psWuDu4h9oz00fX3AeCQ1';
    Stripe.merchantIdentifier = 'qp';
    await Stripe.instance.applySettings();
  }
}
