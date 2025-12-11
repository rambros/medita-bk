import 'package:medita_bk/data/models/firebase/music_model.dart';
import 'package:medita_bk/data/services/firebase/firestore_service.dart';

/// Repository for musics collection (replaces MusicsRecord queries)
class MusicRepository {
  MusicRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;
  static const String _collection = 'musics';

  Stream<List<MusicModel>> streamMusics({int? limit}) {
    return _firestoreService.streamCollection(
      collectionPath: _collection,
      fromSnapshot: MusicModel.fromFirestore,
      queryBuilder: (query) {
        var q = query.orderBy('title');
        if (limit != null) {
          q = q.limit(limit);
        }
        return q;
      },
    );
  }

  Future<List<MusicModel>> getMusics({int? limit}) {
    return _firestoreService.getCollection(
      collectionPath: _collection,
      fromSnapshot: MusicModel.fromFirestore,
      queryBuilder: (query) => query.orderBy('title'),
      limit: limit,
    );
  }

  Future<MusicModel?> getMusicById(String id) {
    return _firestoreService.getDocument(
      collectionPath: _collection,
      documentId: id,
      fromSnapshot: MusicModel.fromFirestore,
    );
  }
}
