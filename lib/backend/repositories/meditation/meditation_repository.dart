import '/backend/backend.dart';
import '/custom_code/actions/index.dart' as actions;

abstract class MeditationRepository {
  Stream<List<MeditationsRecord>> getMeditations();
  Future<List<MeditationsRecord>> getMeditationsOrdered(String orderBy);
  Future<List<MeditationsRecord>> getMeditationsFiltered(List<String> categories);
  Future<List<MeditationsRecord>> searchMeditations(String term);
  Future<List<MeditationsRecord>> getFavoriteMeditations(String userId);
}

class MeditationRepositoryImpl implements MeditationRepository {
  @override
  Stream<List<MeditationsRecord>> getMeditations() {
    return queryMeditationsRecord(
      queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('date', descending: true),
    );
  }

  @override
  Future<List<MeditationsRecord>> getMeditationsOrdered(String orderBy) {
    if (orderBy == 'orderByNumPlayed') {
      return queryMeditationsRecordOnce(
        queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('numPlayed', descending: true),
      );
    } else if (orderBy == 'orderByNewest') {
      return queryMeditationsRecordOnce(
        queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('date', descending: true),
      );
    } else if (orderBy == 'orderByFavourites') {
      return queryMeditationsRecordOnce(
        queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('numLiked', descending: true),
      );
    } else if (orderBy == 'orderByLongest') {
      return queryMeditationsRecordOnce(
        queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('audioDuration', descending: true),
      );
    } else if (orderBy == 'orderByShortest') {
      return queryMeditationsRecordOnce(
        queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('audioDuration'),
      );
    }
    // Default to newest
    return queryMeditationsRecordOnce(
      queryBuilder: (meditationsRecord) => meditationsRecord.orderBy('date', descending: true),
    );
  }

  @override
  Future<List<MeditationsRecord>> getMeditationsFiltered(List<String> categories) {
    return queryMeditationsRecordOnce(
      queryBuilder: (meditationsRecord) => meditationsRecord.where(
        'category',
        arrayContainsAny: categories,
      ),
    );
  }

  @override
  Future<List<MeditationsRecord>> searchMeditations(String term) async {
    return MeditationsRecord.search(term: term);
  }

  @override
  Future<List<MeditationsRecord>> getFavoriteMeditations(String userId) async {
    return await actions.getFavoritesMeditations(userId);
  }
}
