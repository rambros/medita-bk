import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  final String id;
  final String name;
  final int order;

  Section({required this.id, required this.name, required this.order});

  factory Section.fromFiresore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return Section(id: snap.id, name: d['name'], order: d['order']);
  }

  static Map<String, dynamic> getMap(Section d) {
    return {'name': d.name, 'order': d.order};
  }
}
