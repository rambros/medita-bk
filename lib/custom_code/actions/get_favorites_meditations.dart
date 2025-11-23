// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<MeditationsRecord>> getFavoritesMeditations(String userId) async {
  // Add your function code here!
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Fetch the user's document
  DocumentSnapshot userDoc =
      await firestore.collection('users').doc(userId).get();

  // Check if the user document exists and has a favorites field
  if (userDoc.exists && userDoc.data() != null) {
    List<dynamic> favorites = userDoc['favorites'] ?? [];

    // Create a list to hold the meditation records
    List<MeditationsRecord> favoriteMeditations = [];

    // Fetch each meditation by its ID
    for (String meditationId in favorites) {
      DocumentSnapshot meditationDoc =
          await firestore.collection('meditations').doc(meditationId).get();
      if (meditationDoc.exists) {
        // Assuming MeditationsRecord has a fromDocument method to create an instance from a Firestore document
        favoriteMeditations.add(MeditationsRecord.fromSnapshot(meditationDoc));
      }
    }

    return favoriteMeditations;
  }

  return []; // Return an empty list if no favorites found
}
