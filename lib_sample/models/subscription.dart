import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String plan, productId;
  DateTime purchaseAt, expireAt;

  Subscription({
    required this.plan,
    required this.purchaseAt,
    required this.expireAt,
    required this.productId,
  });

  factory Subscription.fromFirestore(Map<String, dynamic> d) {
    return Subscription(
        plan: d['plan'],
        purchaseAt: (d['purchased_at'] as Timestamp).toDate(),
        expireAt: (d['end_at'] as Timestamp).toDate(),
        productId: d['product_id']);
  }

  static Map<String, dynamic> getMap(Subscription d) {
    return {
      'plan': d.plan,
      'purchased_at': d.purchaseAt,
      'end_at': d.expireAt,
      'product_id': d.productId,
    };
  }
}
