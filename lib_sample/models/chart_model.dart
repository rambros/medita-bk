import 'package:cloud_firestore/cloud_firestore.dart';

class ChartModel {
  final DateTime timestamp;
  final int count;
  final String id;

  ChartModel({
    required this.timestamp,
    required this.count,
    required this.id,
  });

  factory ChartModel.fromFirestore(DocumentSnapshot snap) {
    final d = snap.data() as Map<String, dynamic>;
    return ChartModel(
      id: snap.id,
      timestamp: (d['timestamp'] as Timestamp).toDate(),
      count: d['count'],
    );
  }

  static Map<String, dynamic> getMap (ChartModel d){
    return {
      'timestamp': d.timestamp,
      'count': d.count,
    };
  }
}