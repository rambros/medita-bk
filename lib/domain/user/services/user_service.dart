import '/backend/backend.dart';

/// Service for user-related utilities and migration scripts
class UserService {
  /// Bulk update profile pictures (migration script)
  ///
  /// Changes userImageUrl for all users with the old URL to the new URL.
  /// This is a one-time migration function.
  static Future<void> changeProfilePic() async {
    // Get the reference to the user collection in Firebase
    final users = FirebaseFirestore.instance.collection('users');
    const oldUrl =
        'https://img2.pngio.com/graphic-design-communication-design-instructional-design-divergent-thinking-png-512_512.jpg';
    const newUrl =
        'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/app_images%2Fstar_small.png?alt=media&token=e2375a94-b069-4c88-979f-7a3d82f14a68';

    // Query the collection to get all documents with userImageUrl equal to 'oldUrl'
    final snapshot = await users.where('userImageUrl', isEqualTo: oldUrl).get();

    // Loop through each document and update the userImageUrl field
    for (final doc in snapshot.docs) {
      // Update the userImageUrl field to a new value
      await users.doc(doc.id).update({'userImageUrl': newUrl});
    }
  }
}
