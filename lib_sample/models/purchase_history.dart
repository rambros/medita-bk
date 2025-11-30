import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistory {
  final String id, userId, userName, userEmail, plan, price, platform;
  final String? purchaseId, userImageUrl;
  DateTime purchaseAt, expireAt;

  PurchaseHistory({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.plan,
    required this.purchaseAt,
    required this.expireAt,
    this.purchaseId,
    required this.price,
    this.userImageUrl,
    required this.platform,
  });

  factory PurchaseHistory.fromFirestore(DocumentSnapshot snapshot) {
    final d = snapshot.data() as Map<String, dynamic>;
    return PurchaseHistory(
      id: snapshot.id,
      userId: d['user_id'],
      userName: d['user_id'],
      plan: d['plan'],
      userEmail: d['user_email'],
      purchaseAt: (d['purchase_at'] as Timestamp).toDate(),
      expireAt: (d['expire_at'] as Timestamp).toDate(),
      price: d['price'],
      purchaseId: d['purchase_id'],
      userImageUrl: d['user_image_url'],
      platform: d['platform'] ?? 'Android',
    );
  }

  static Map<String, dynamic> getMap(PurchaseHistory d) {
    return {
      'plan': d.plan,
      'user_id': d.userId,
      'user_name': d.userName,
      'user_email': d.userEmail,
      'purchase_at': d.purchaseAt,
      'expire_at': d.expireAt,
      'price': d.price,
      'purchase_id': d.purchaseId,
      'user_image_url': d.userImageUrl,
      'platform': d.platform,
    };
  }
}
