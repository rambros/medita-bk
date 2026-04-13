import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:medita_bk/core/utils/logger.dart';

class CloudFunctionsService {
  static const _projectId = 'meditabk2020';
  static const _region = 'us-central1';

  static Future<Map<String, dynamic>> makeCloudCall(
    String callName,
    Map<String, dynamic> input,
  ) async {
    // iOS crashes in the native Firebase Functions SDK due to a Swift Concurrency
    // bug (asyncLet_finish_after_task_completion abort in HTTPSCallable.call).
    // Confirmed on iOS 18.6.2 and iOS 26.4 — applies to all iOS versions.
    // Use direct HTTP to bypass the native SDK until Firebase releases a fix.
    if (Platform.isIOS) {
      return _makeDirectHttpCall(callName, input);
    }

    try {
      final response = await FirebaseFunctions.instance
          .httpsCallable(callName, options: HttpsCallableOptions())
          .call(input);
      return response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : {};
    } on FirebaseFunctionsException catch (e) {
      logDebug(
        'Cloud call error!\n$callName'
        'Code: ${e.code}\n'
        'Details: ${e.details}\n'
        'Message: ${e.message}',
        error: e,
      );
    } catch (e) {
      logDebug('Cloud call error:$callName $e');
    }
    return {};
  }

  static Future<Map<String, dynamic>> _makeDirectHttpCall(
    String callName,
    Map<String, dynamic> input,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      final url = Uri.parse(
        'https://$_region-$_projectId.cloudfunctions.net/$callName',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'data': input}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['result'] is Map) {
          return Map<String, dynamic>.from(decoded['result'] as Map);
        }
        return {};
      } else {
        logDebug('Direct HTTP call error: $callName status=${response.statusCode}');
      }
    } catch (e) {
      logDebug('Direct HTTP call error: $callName $e');
    }
    return {};
  }

}
