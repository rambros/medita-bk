import 'dart:async';

import 'serialization_util.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({super.key, required this.child});

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() => _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    safeSetState(() => _loading = true);
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        if (mounted) {
          context.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        } else {
          appNavigatorKey.currentContext?.pushNamed(
            initialPageName,
            pathParameters: parameterData.pathParameters,
            extra: parameterData.extra,
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      safeSetState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? isWeb
          ? Container()
          : Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
              child: Center(
                child: Image.asset(
                  'assets/images/logo_meditabk.png',
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  fit: BoxFit.contain,
                ),
              ),
            )
      : widget.child;
}

class ParameterData {
  const ParameterData({this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() => (data) async => const ParameterData();
}

final parametersBuilderMap = <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'signIn': ParameterData.none(),
  'signUp': ParameterData.none(),
  'editProfilePage': ParameterData.none(),
  'forgotPassword': ParameterData.none(),
  'homePage': ParameterData.none(),
  'profilePage': ParameterData.none(),
  'meditationHomePage': ParameterData.none(),
  'notificationListPage': ParameterData.none(),
  'SociallLogin': ParameterData.none(),
  'configPage': ParameterData.none(),
  'aboutPage': ParameterData.none(),
  'changeEmailPage': ParameterData.none(),
  'appReviewPage': ParameterData.none(),
  'SettingsPage': ParameterData.none(),
  'invitePage': ParameterData.none(),
  'deleteAccountPage': ParameterData.none(),
  'aboutAuthorsPage': ParameterData.none(),
  'alarmPage': ParameterData.none(),
  'meditationDetailsPage': (data) async => ParameterData(
        allParams: {
          'meditationDocRef': getParameter<DocumentReference>(data, 'meditationDocRef'),
          'meditationId': getParameter<String>(data, 'meditationId'),
        },
      ),
  'meditationPlayPage': (data) async => ParameterData(
        allParams: {
          'meditationId': getParameter<String>(data, 'meditationId'),
        },
      ),
  'meditationListPage': ParameterData.none(),
  'videoHomePage': ParameterData.none(),
  'youtubePlayerPage': (data) async => ParameterData(
        allParams: {
          'videoTitle': getParameter<String>(data, 'videoTitle'),
          'videoId': getParameter<String>(data, 'videoId'),
        },
      ),
  'congressoListPage': ParameterData.none(),
  'entrevistasListPage': ParameterData.none(),
  'agendaHomePage': ParameterData.none(),
  'mensagensHomePage': ParameterData.none(),
  'agendaListPage': ParameterData.none(),
  'eventDetailsPage': (data) async => const ParameterData(
        allParams: <String, dynamic>{},
      ),
  'eventListPage': ParameterData.none(),
  'mensagemDetailsPage': ParameterData.none(),
  'mensagemShowPage': (data) async => ParameterData(
        allParams: {
          'tema': getParameter<String>(data, 'tema'),
          'mensagem': getParameter<String>(data, 'mensagem'),
        },
      ),
  'meditationVideoListPage': ParameterData.none(),
  'meditationStatisticsPage': ParameterData.none(),
  'playlistListPage': ParameterData.none(),
  'playlistDetailsPage': (data) async => ParameterData(
        allParams: {
          'playlistIndex': getParameter<int>(data, 'playlistIndex'),
          'idPlaylist': getParameter<String>(data, 'idPlaylist'),
        },
      ),
  'playlistAddAudiosPage': ParameterData.none(),
  'selectinstrumentPage': ParameterData.none(),
  'selectMusicPage': ParameterData.none(),
  'selectMeditationsPage': ParameterData.none(),
  'selectDeviceMusicPage': ParameterData.none(),
  'playlistSavePage': ParameterData.none(),
  'playlistEditPage': (data) async => ParameterData(
        allParams: {
          'playlistIndex': getParameter<int>(data, 'playlistIndex'),
          'idPlaylist': getParameter<String>(data, 'idPlaylist'),
        },
      ),
  'playlistEditAudiosPage': (data) async => ParameterData(
        allParams: {
          'playlistIndex': getParameter<int>(data, 'playlistIndex'),
        },
      ),
  'playlistPlayPageOld': ParameterData.none(),
  'mensagensSemanticSearchPage': ParameterData.none(),
  'canalViverListPage': ParameterData.none(),
  'palestrasListPage': ParameterData.none(),
  'supportPage': ParameterData.none(),
  'feedbackPage': ParameterData.none(),
  'featurePage': ParameterData.none(),
  'donationPage': ParameterData.none(),
  'playlistPlayPage': ParameterData.none(),
  'meditationPlayPageOld': (data) async => ParameterData(
        allParams: {
          'meditationId': getParameter<String>(data, 'meditationId'),
        },
      ),
  'playlistAudioPlayPage': (data) async => ParameterData(
        allParams: {
          'audio': getParameter<String>(data, 'audio'),
          'title': getParameter<String>(data, 'title'),
          'header': getParameter<String>(data, 'header'),
        },
      ),
  'homeDesafioPage': ParameterData.none(),
  'listaEtapasPage': ParameterData.none(),
  'desafioPlayPage': (data) async => ParameterData(
        allParams: {
          'indiceListaMeditacao': getParameter<int>(data, 'indiceListaMeditacao'),
        },
      ),
  'completouMeditacaoPage': (data) async => ParameterData(
        allParams: {
          'parmDiaCompletado': getParameter<int>(data, 'parmDiaCompletado'),
        },
      ),
  'completouMandalaPage': (data) async => ParameterData(
        allParams: {
          'diaCompletado': getParameter<int>(data, 'diaCompletado'),
          'etapaCompletada': getParameter<int>(data, 'etapaCompletada'),
          'parmMandalaUrl': getParameter<String>(data, 'parmMandalaUrl'),
        },
      ),
  'completouBrasaoPage': (data) async => ParameterData(
        allParams: {
          'indiceBrasao': getParameter<int>(data, 'indiceBrasao'),
        },
      ),
  'visualizarPremioPage': (data) async => ParameterData(
        allParams: {
          'indiceBrasao': getParameter<int>(data, 'indiceBrasao'),
        },
      ),
  'desafioOnboardingPage': ParameterData.none(),
  'diarioMeditacaoPage': ParameterData.none(),
  'diarioDetalhesPage': (data) async => const ParameterData(
        allParams: <String, dynamic>{},
      ),
  'conquistasPage': ParameterData.none(),
  'youtubePlayerPageCopy': (data) async => ParameterData(
        allParams: {
          'videoTitle': getParameter<String>(data, 'videoTitle'),
          'videoId': getParameter<String>(data, 'videoId'),
        },
      ),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null || parameterDataStr is! String || parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
