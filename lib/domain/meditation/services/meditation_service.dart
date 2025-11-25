import '/backend/backend.dart';

/// Service for meditation-specific business logic
class MeditationService {
  /// Get user's favorite meditations
  ///
  /// Fetches all meditation records that are in the user's favorites list.
  static Future<List<MeditationsRecord>> getFavoritesMeditations(
    String userId,
  ) async {
    final firestore = FirebaseFirestore.instance;

    // Fetch the user's document
    final userDoc = await firestore.collection('users').doc(userId).get();

    // Check if the user document exists and has a favorites field
    if (userDoc.exists && userDoc.data() != null) {
      final List<dynamic> favorites = userDoc['favorites'] ?? [];

      // Create a list to hold the meditation records
      final List<MeditationsRecord> favoriteMeditations = [];

      // Fetch each meditation by its ID
      for (final String meditationId in favorites) {
        final meditationDoc = await firestore.collection('meditations').doc(meditationId).get();
        if (meditationDoc.exists) {
          favoriteMeditations.add(MeditationsRecord.fromSnapshot(meditationDoc));
        }
      }

      return favoriteMeditations;
    }

    return []; // Return an empty list if no favorites found
  }
}
