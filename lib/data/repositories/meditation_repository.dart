import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medita_b_k/data/models/firebase/meditation_model.dart';
import 'package:medita_b_k/data/services/firebase/firestore_service.dart';
import 'package:medita_b_k/core/utils/logger.dart';
import 'package:medita_b_k/data/services/algolia_service.dart';

/// Repository interface for meditation data operations
abstract class MeditationRepository {
  Stream<List<MeditationModel>> getMeditations();
  Future<List<MeditationModel>> getMeditationsOrdered(String orderBy);
  Future<List<MeditationModel>> getMeditationsFiltered(List<String> categories);
  Future<List<MeditationModel>> searchMeditations(String term);
  Future<List<MeditationModel>> getFavoriteMeditations(String userId);
  Future<MeditationModel?> getMeditationById(String meditationId);
  Stream<MeditationModel?> streamMeditationById(String meditationId);
  Future<void> incrementPlayCount(String meditationId);
  Future<void> incrementLikeCount(String meditationId);
  Future<void> decrementLikeCount(String meditationId);
}

/// Implementation of MeditationRepository using FirestoreService
class MeditationRepositoryImpl implements MeditationRepository {
  final FirestoreService _firestoreService;
  static const String _collectionPath = 'meditations';

  MeditationRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // ========== QUERY METHODS ==========

  @override
  Stream<List<MeditationModel>> getMeditations() {
    logDebug('MeditationRepository: Getting meditations stream from $_collectionPath');
    return _firestoreService.streamCollection(
      collectionPath: _collectionPath,
      fromSnapshot: MeditationModel.fromFirestore,
      queryBuilder: (query) => query.orderBy('date', descending: true),
    ).handleError((error) {
      logDebug('MeditationRepository: Error getting meditations: $error');
    });
  }

  @override
  Future<MeditationModel?> getMeditationById(String meditationId) async {
    try {
      return await _firestoreService.getDocument(
        collectionPath: _collectionPath,
        documentId: meditationId,
        fromSnapshot: MeditationModel.fromFirestore,
      );
    } catch (e) {
      logDebug('Error fetching meditation by ID: $e');
      rethrow;
    }
  }

  @override
  Stream<MeditationModel?> streamMeditationById(String meditationId) {
    return _firestoreService.streamDocument(
      collectionPath: _collectionPath,
      documentId: meditationId,
      fromSnapshot: MeditationModel.fromFirestore,
    );
  }

  @override
  Future<List<MeditationModel>> getMeditationsOrdered(String orderBy) async {
    try {
      return await _firestoreService.getCollection(
        collectionPath: _collectionPath,
        fromSnapshot: MeditationModel.fromFirestore,
        queryBuilder: (query) {
          switch (orderBy) {
            case 'orderByNumPlayed':
              return query.orderBy('numPlayed', descending: true);
            case 'orderByNewest':
              return query.orderBy('date', descending: true);
            case 'orderByFavourites':
              return query.orderBy('numLiked', descending: true);
            case 'orderByLongest':
              return query.orderBy('audioDuration', descending: true);
            case 'orderByShortest':
              return query.orderBy('audioDuration');
            default:
              // Default to newest
              return query.orderBy('date', descending: true);
          }
        },
      );
    } catch (e) {
      logDebug('Error fetching ordered meditations: $e');
      rethrow;
    }
  }

  @override
  Future<List<MeditationModel>> getMeditationsFiltered(List<String> categories) async {
    try {
      if (categories.isEmpty) {
        return await _firestoreService.getCollection(
          collectionPath: _collectionPath,
          fromSnapshot: MeditationModel.fromFirestore,
        );
      }

      return await _firestoreService.getCollection(
        collectionPath: _collectionPath,
        fromSnapshot: MeditationModel.fromFirestore,
        queryBuilder: (query) => query.where(
          'category',
          arrayContainsAny: categories,
        ),
      );
    } catch (e) {
      logDebug('Error fetching filtered meditations: $e');
      rethrow;
    }
  }

  @override
  Future<List<MeditationModel>> searchMeditations(String term) async {
    try {
      // Use Algolia for search
      final results = await AlgoliaService.instance.algoliaQuery(
        index: 'meditations',
        term: term,
        maxResults: 50,
        useCache: false,
      );

      // Convert Algolia results to MeditationModel
      return results.map((snapshot) => _fromAlgolia(snapshot)).toList();
    } catch (e) {
      logDebug('Error searching meditations: $e');
      rethrow;
    }
  }

  @override
  Future<List<MeditationModel>> getFavoriteMeditations(String userId) async {
    try {
      // First, get user to get favorites list
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return [];
      }

      final userData = userDoc.data();
      final favorites = (userData?['favorites'] as List?)?.cast<String>() ?? [];

      if (favorites.isEmpty) {
        return [];
      }

      // Firestore 'in' query limit is 10, so we need to batch
      final List<MeditationModel> allFavorites = [];

      for (int i = 0; i < favorites.length; i += 10) {
        final batch = favorites.skip(i).take(10).toList();

        final batchResults = await _firestoreService.getCollection(
          collectionPath: _collectionPath,
          fromSnapshot: MeditationModel.fromFirestore,
          queryBuilder: (query) => query.where(
            FieldPath.documentId,
            whereIn: batch,
          ),
        );

        allFavorites.addAll(batchResults);
      }

      return allFavorites;
    } catch (e) {
      logDebug('Error fetching favorite meditations: $e');
      rethrow;
    }
  }

  // ========== WRITE METHODS ==========

  @override
  Future<void> incrementPlayCount(String meditationId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: meditationId,
        data: {
          'numPlayed': FieldValue.increment(1),
        },
      );
    } catch (e) {
      logDebug('Error incrementing play count: $e');
      rethrow;
    }
  }

  @override
  Future<void> incrementLikeCount(String meditationId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: meditationId,
        data: {
          'numLiked': FieldValue.increment(1),
        },
      );
    } catch (e) {
      logDebug('Error incrementing like count: $e');
      rethrow;
    }
  }

  @override
  Future<void> decrementLikeCount(String meditationId) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _collectionPath,
        documentId: meditationId,
        data: {
          'numLiked': FieldValue.increment(-1),
        },
      );
    } catch (e) {
      logDebug('Error decrementing like count: $e');
      rethrow;
    }
  }

  // ========== HELPER METHODS ==========

  /// Convert Algolia snapshot to MeditationModel
  MeditationModel _fromAlgolia(AlgoliaObjectSnapshot snapshot) {
    // Extract data from Algolia snapshot
    final algoliaData = snapshot.data;

    return MeditationModel(
      id: snapshot.objectID,
      documentId: algoliaData['documentId'] as String? ?? '',
      title: algoliaData['title'] as String? ?? '',
      authorId: algoliaData['authorId'] as String? ?? '',
      authorName: algoliaData['authorName'] as String? ?? '',
      authorText: algoliaData['authorText'] as String? ?? '',
      authorMusic: algoliaData['authorMusic'] as String? ?? '',
      date: algoliaData['date'] as String? ?? '',
      featured: algoliaData['featured'] as bool? ?? false,
      imageFileName: algoliaData['imageFileName'] as String? ?? '',
      audioFileName: algoliaData['audioFileName'] as String? ?? '',
      audioDuration: algoliaData['audioDuration'] as String? ?? '',
      callText: algoliaData['callText'] as String? ?? '',
      detailsText: algoliaData['detailsText'] as String? ?? '',
      numPlayed: algoliaData['numPlayed'] as int? ?? 0,
      numLiked: algoliaData['numLiked'] as int? ?? 0,
      category: (algoliaData['category'] as List?)?.cast<String>() ?? [],
      titleIndex: (algoliaData['titleIndex'] as List?)?.cast<String>() ?? [],
      imageUrl: algoliaData['imageUrl'] as String? ?? '',
      audioUrl: algoliaData['audioUrl'] as String? ?? '',
    );
  }
}
