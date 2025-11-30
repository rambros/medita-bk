import 'package:cloud_firestore/cloud_firestore.dart';

class Tag {
  final String name, id;
  DateTime createdAt;

  Tag({
    required this.name,
    required this.id,
    required this.createdAt
  });

  factory Tag.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return Tag(
        id: snap.id,
        name: d['name'],
        createdAt: (d['created_at'] as Timestamp).toDate()
    );
  }
}