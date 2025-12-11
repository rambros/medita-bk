import 'dart:io' show Platform;

import 'package:medita_bk/data/services/auth/firebase_auth/auth_util.dart';
import 'package:medita_bk/data/services/cloud_functions_service.dart';

import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


export '/data/services/push_notifications/push_notifications_handler.dart';
export '/data/services/push_notifications/serialization_util.dart';

class UserTokenInfo {
  const UserTokenInfo(this.userPath, this.fcmToken);
  final String userPath;
  final String fcmToken;
}

Stream<UserTokenInfo> getFcmTokenStream(String userPath) =>
    Stream.value(!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        .where((shouldGetToken) => shouldGetToken)
        .asyncMap<String?>((_) => FirebaseMessaging.instance.requestPermission().then(
              (settings) => settings.authorizationStatus == AuthorizationStatus.authorized
                  ? FirebaseMessaging.instance.getToken()
                  : null,
            ))
        .switchMap((fcmToken) => Stream.value(fcmToken).merge(FirebaseMessaging.instance.onTokenRefresh))
        .where((fcmToken) => fcmToken != null && fcmToken.isNotEmpty)
        .map((token) => UserTokenInfo(userPath, token!));

final fcmTokenUserStream = authenticatedUserStream
    .where((user) => user != null)
    .map((user) => 'users/${user!.uid}')
    .distinct()
    .switchMap(getFcmTokenStream)
    .map(
      (userTokenInfo) => CloudFunctionsService.makeCloudCall(
        'addFcmToken',
        {
          'userDocPath': userTokenInfo.userPath,
          'fcmToken': userTokenInfo.fcmToken,
          'deviceType': Platform.isIOS ? 'iOS' : 'Android',
        },
      ),
    );
