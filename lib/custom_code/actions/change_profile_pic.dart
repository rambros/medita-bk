// Automatic FlutterFlow imports
import '/backend/backend.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom actions

Future changeProfilePic() async {
  // create a function that read all records in an user coleection in firebase and change the value of a field userImageUrl only for records that have value equal 'oldUrl'

  // Get the reference to the user collection in Firebase
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var oldUrl =
      'https://img2.pngio.com/graphic-design-communication-design-instructional-design-divergent-thinking-png-512_512.jpg';
  var newUrl =
      'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/app_images%2Fstar_small.png?alt=media&token=e2375a94-b069-4c88-979f-7a3d82f14a68';

  // Query the collection to get all documents with userImageUrl equal to 'oldUrl'
  QuerySnapshot snapshot =
      await users.where('userImageUrl', isEqualTo: oldUrl).get();

  // Loop through each document and update the userImageUrl field
  for (var doc in snapshot.docs) {
    // Update the userImageUrl field to a new value
    await users.doc(doc.id).update({'userImageUrl': newUrl});
  }
}
