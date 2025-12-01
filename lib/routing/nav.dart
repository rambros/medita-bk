import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/structs/util/schema_util.dart';
import '/core/structs/d21_meditation_model_struct.dart';

import '/data/services/auth/base_auth_user_provider.dart';

import '/data/services/push_notifications/push_notifications_handler.dart' show PushNotificationsHandler;
import '/ui/pages.dart';
import '/routing/ead_routes.dart';
import '/main.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._() {
    // Always clear splash after a short delay to avoid getting stuck.
    Timer(const Duration(seconds: 3), () {
      if (showSplashImage) {
        stopShowingSplashImage();
      }
    });
  }

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  // Start with splash visible; main() will clear this via timers/failsafe.
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  // Splash should only depend on the explicit flag, not auth availability, so we
  // don't block the UI when the auth stream is slow or emits null.
  bool get loading => showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate = user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.loggedIn ? const NavBarPage() : const SocialLoginPage(),
      extraCodec: const FFExtraCodec(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn ? const NavBarPage() : const SocialLoginPage(),
          routes: [
            FFRoute(
              name: SignInPage.routeName,
              path: SignInPage.routePath,
              builder: (context, params) => const SignInPage(),
            ),
            FFRoute(
              name: SignUpPage.routeName,
              path: SignUpPage.routePath,
              builder: (context, params) => const SignUpPage(),
            ),
            FFRoute(
              name: EditProfilePage.routeName,
              path: EditProfilePage.routePath,
              builder: (context, params) => const EditProfilePage(),
            ),
            FFRoute(
              name: ForgotPasswordPage.routeName,
              path: ForgotPasswordPage.routePath,
              builder: (context, params) => const ForgotPasswordPage(),
            ),
            FFRoute(
              name: HomePage.routeName,
              path: HomePage.routePath,
              builder: (context, params) =>
                  params.isEmpty ? const NavBarPage(initialPage: 'homePage') : const HomePage(),
            ),
            FFRoute(
              name: ProfilePage.routeName,
              path: ProfilePage.routePath,
              builder: (context, params) => const ProfilePage(),
            ),
            FFRoute(
              name: MeditationHomePage.routeName,
              path: MeditationHomePage.routePath,
              builder: (context, params) => params.isEmpty
                  ? const NavBarPage(initialPage: 'meditationHomePage')
                  : const MeditationHomePage(),
            ),
            FFRoute(
              name: NotificationListPage.routeName,
              path: NotificationListPage.routePath,
              builder: (context, params) => const NotificationListPage(),
            ),
            FFRoute(
              name: SocialLoginPage.routeName,
              path: SocialLoginPage.routePath,
              builder: (context, params) => const SocialLoginPage(),
            ),
            FFRoute(
              name: ConfigPage.routeName,
              path: ConfigPage.routePath,
              builder: (context, params) => const ConfigPage(),
            ),
            FFRoute(
              name: AboutPage.routeName,
              path: AboutPage.routePath,
              builder: (context, params) => const AboutPage(),
            ),
            FFRoute(
              name: ChangeEmailPage.routeName,
              path: ChangeEmailPage.routePath,
              builder: (context, params) => const ChangeEmailPage(),
            ),
            FFRoute(
              name: AppReviewPage.routeName,
              path: AppReviewPage.routePath,
              builder: (context, params) => const AppReviewPage(),
            ),
            FFRoute(
              name: SettingsPage.routeName,
              path: SettingsPage.routePath,
              builder: (context, params) => const SettingsPage(),
            ),
            FFRoute(
              name: InvitePage.routeName,
              path: InvitePage.routePath,
              builder: (context, params) => const InvitePage(),
            ),
            FFRoute(
              name: DeleteAccountPage.routeName,
              path: DeleteAccountPage.routePath,
              builder: (context, params) => const DeleteAccountPage(),
            ),
            FFRoute(
              name: AboutAuthorsPage.routeName,
              path: AboutAuthorsPage.routePath,
              builder: (context, params) => const AboutAuthorsPage(),
            ),
            FFRoute(
              name: AlarmPage.routeName,
              path: AlarmPage.routePath,
              builder: (context, params) => const AlarmPage(),
            ),
            FFRoute(
              name: MeditationDetailsPage.routeName,
              path: MeditationDetailsPage.routePath,
              builder: (context, params) => MeditationDetailsPage(
                meditationDocRef: () {
                  final meditationId = params.getParam(
                    'meditationId',
                    ParamType.String,
                  );
                  if (meditationId != null && meditationId.isNotEmpty) {
                    return FirebaseFirestore.instance.collection('meditations').doc(meditationId);
                  }

                  final docRef = params.getParam(
                    'meditationDocRef',
                    ParamType.DocumentReference,
                    isList: false,
                    collectionNamePath: const ['meditations'],
                  );
                  return docRef;
                }(),
              ),
            ),
            FFRoute(
              name: MeditationPlayPage.routeName,
              path: MeditationPlayPage.routePath,
              builder: (context, params) => MeditationPlayPage(
                meditationId: params.getParam(
                  'meditationId',
                  ParamType.String,
                  isList: false,
                )!,
              ),
            ),
            FFRoute(
              name: MeditationListPage.routeName,
              path: MeditationListPage.routePath,
              builder: (context, params) => const MeditationListPage(),
            ),
            FFRoute(
              name: VideoHomePage.routeName,
              path: VideoHomePage.routePath,
              builder: (context, params) =>
                  params.isEmpty ? const NavBarPage(initialPage: 'videoHomePage') : const VideoHomePage(),
            ),
            FFRoute(
              name: YoutubePlayerPage.routeName,
              path: YoutubePlayerPage.routePath,
              builder: (context, params) => YoutubePlayerPage(
                videoTitle: params.getParam(
                  'videoTitle',
                  ParamType.String,
                ),
                videoId: params.getParam(
                  'videoId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: CongressoListPage.routeName,
              path: CongressoListPage.routePath,
              builder: (context, params) => const CongressoListPage(),
            ),
            FFRoute(
              name: EntrevistasListPage.routeName,
              path: EntrevistasListPage.routePath,
              builder: (context, params) => const EntrevistasListPage(),
            ),
            FFRoute(
              name: AgendaHomePage.routeName,
              path: AgendaHomePage.routePath,
              builder: (context, params) =>
                  params.isEmpty ? const NavBarPage(initialPage: 'agendaHomePage') : const AgendaHomePage(),
            ),
            FFRoute(
              name: MensagensHomePage.routeName,
              path: MensagensHomePage.routePath,
              builder: (context, params) =>
                  params.isEmpty ? const NavBarPage(initialPage: 'mensagensHomePage') : const MensagensHomePage(),
            ),
            FFRoute(
              name: AgendaListPage.routeName,
              path: AgendaListPage.routePath,
              builder: (context, params) => const AgendaListPage(),
            ),
            FFRoute(
              name: EventDetailsPage.routeName,
              path: EventDetailsPage.routePath,
              builder: (context, params) => EventDetailsPage(
                eventDoc: params.getParam(
                  'eventDoc',
                  ParamType.JSON,
                ),
              ),
            ),
            FFRoute(
              name: EventListPage.routeName,
              path: EventListPage.routePath,
              builder: (context, params) => const EventListPage(),
            ),
            FFRoute(
              name: MensagemDetailsPage.routeName,
              path: MensagemDetailsPage.routePath,
              builder: (context, params) => const MensagemDetailsPage(),
            ),
            FFRoute(
              name: MensagemShowPage.routeName,
              path: MensagemShowPage.routePath,
              builder: (context, params) => MensagemShowPage(
                tema: params.getParam(
                  'tema',
                  ParamType.String,
                ),
                mensagem: params.getParam(
                  'mensagem',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: MeditationVideoListPage.routeName,
              path: MeditationVideoListPage.routePath,
              builder: (context, params) => const MeditationVideoListPage(),
            ),
            FFRoute(
              name: MeditationStatisticsPage.routeName,
              path: MeditationStatisticsPage.routePath,
              builder: (context, params) => const MeditationStatisticsPage(),
            ),
            FFRoute(
              name: PlaylistListPage.routeName,
              path: PlaylistListPage.routePath,
              builder: (context, params) => const PlaylistListPage(),
            ),
            FFRoute(
              name: PlaylistDetailsPage.routeName,
              path: PlaylistDetailsPage.routePath,
              builder: (context, params) => PlaylistDetailsPage(
                playlistIndex: params.getParam(
                  'playlistIndex',
                  ParamType.int,
                ),
                idPlaylist: params.getParam(
                  'idPlaylist',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: PlaylistAddAudiosPage.routeName,
              path: PlaylistAddAudiosPage.routePath,
              builder: (context, params) => const PlaylistAddAudiosPage(),
            ),
            FFRoute(
              name: SelectinstrumentPage.routeName,
              path: SelectinstrumentPage.routePath,
              builder: (context, params) => const SelectinstrumentPage(),
            ),
            FFRoute(
              name: SelectMusicPage.routeName,
              path: SelectMusicPage.routePath,
              builder: (context, params) => const SelectMusicPage(),
            ),
            FFRoute(
              name: SelectMeditationsPage.routeName,
              path: SelectMeditationsPage.routePath,
              builder: (context, params) => const SelectMeditationsPage(),
            ),
            FFRoute(
              name: SelectDeviceMusicPage.routeName,
              path: SelectDeviceMusicPage.routePath,
              builder: (context, params) => const SelectDeviceMusicPage(),
            ),
            FFRoute(
              name: PlaylistSavePage.routeName,
              path: PlaylistSavePage.routePath,
              builder: (context, params) => const PlaylistSavePage(),
            ),
            FFRoute(
              name: PlaylistEditPage.routeName,
              path: PlaylistEditPage.routePath,
              builder: (context, params) => PlaylistEditPage(
                playlistIndex: params.getParam(
                  'playlistIndex',
                  ParamType.int,
                ),
                idPlaylist: params.getParam(
                  'idPlaylist',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: PlaylistEditAudiosPage.routeName,
              path: PlaylistEditAudiosPage.routePath,
              builder: (context, params) => PlaylistEditAudiosPage(
                playlistIndex: params.getParam(
                  'playlistIndex',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: PlaylistPlayPageOldWidget.routeName,
              path: PlaylistPlayPageOldWidget.routePath,
              builder: (context, params) => const PlaylistPlayPageOldWidget(),
            ),
            FFRoute(
              name: MensagensSemanticSearchPage.routeName,
              path: MensagensSemanticSearchPage.routePath,
              builder: (context, params) => const MensagensSemanticSearchPage(),
            ),
            FFRoute(
              name: CanalViverListPage.routeName,
              path: CanalViverListPage.routePath,
              builder: (context, params) => const CanalViverListPage(),
            ),
            FFRoute(
              name: PalestrasListPage.routeName,
              path: PalestrasListPage.routePath,
              builder: (context, params) => const PalestrasListPage(),
            ),
            FFRoute(
              name: SupportPage.routeName,
              path: SupportPage.routePath,
              builder: (context, params) => const SupportPage(),
            ),
            FFRoute(
              name: FeedbackPage.routeName,
              path: FeedbackPage.routePath,
              builder: (context, params) => const FeedbackPage(),
            ),
            FFRoute(
              name: FeaturePage.routeName,
              path: FeaturePage.routePath,
              builder: (context, params) => const FeaturePage(),
            ),
            FFRoute(
              name: DonationPage.routeName,
              path: DonationPage.routePath,
              builder: (context, params) => const DonationPage(),
            ),
            FFRoute(
              name: PlaylistPlayPage.routeName,
              path: PlaylistPlayPage.routePath,
              builder: (context, params) => const PlaylistPlayPage(),
            ),
            FFRoute(
              name: PlaylistAudioPlayPage.routeName,
              path: PlaylistAudioPlayPage.routePath,
              builder: (context, params) => PlaylistAudioPlayPage(
                audio: params.getParam(
                  'audio',
                  ParamType.String,
                ),
                title: params.getParam(
                  'title',
                  ParamType.String,
                ),
                header: params.getParam(
                  'header',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: HomeDesafioPage.routeName,
              path: HomeDesafioPage.routePath,
              builder: (context, params) => const HomeDesafioPage(),
            ),
            FFRoute(
              name: ListaEtapasPage.routeName,
              path: ListaEtapasPage.routePath,
              builder: (context, params) => const ListaEtapasPage(),
            ),
            FFRoute(
              name: DesafioPlayPage.routeName,
              path: DesafioPlayPage.routePath,
              builder: (context, params) => DesafioPlayPage(
                indiceListaMeditacao: params.getParam(
                  'indiceListaMeditacao',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: CompletouMeditacaoPage.routeName,
              path: CompletouMeditacaoPage.routePath,
              builder: (context, params) => CompletouMeditacaoPage(
                parmDiaCompletado: params.getParam(
                  'parmDiaCompletado',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: CompletouMandalaPage.routeName,
              path: CompletouMandalaPage.routePath,
              builder: (context, params) => CompletouMandalaPage(
                diaCompletado: params.getParam(
                  'diaCompletado',
                  ParamType.int,
                ),
                etapaCompletada: params.getParam(
                  'etapaCompletada',
                  ParamType.int,
                ),
                parmMandalaUrl: params.getParam(
                  'parmMandalaUrl',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: CompletouBrasaoPage.routeName,
              path: CompletouBrasaoPage.routePath,
              builder: (context, params) => CompletouBrasaoPage(
                indiceBrasao: params.getParam(
                  'indiceBrasao',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: VisualizarPremioPage.routeName,
              path: VisualizarPremioPage.routePath,
              builder: (context, params) => VisualizarPremioPage(
                indiceBrasao: params.getParam(
                  'indiceBrasao',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: DesafioOnboardingPage.routeName,
              path: DesafioOnboardingPage.routePath,
              builder: (context, params) => const DesafioOnboardingPage(),
            ),
            FFRoute(
              name: DiarioMeditacaoPage.routeName,
              path: DiarioMeditacaoPage.routePath,
              builder: (context, params) => const DiarioMeditacaoPage(),
            ),
            FFRoute(
              name: DiarioDetalhesPage.routeName,
              path: DiarioDetalhesPage.routePath,
              builder: (context, params) => DiarioDetalhesPage(
                listaMeditacoes: params.getParam<D21MeditationModelStruct>(
                  'listaMeditacoes',
                  ParamType.DataStruct,
                  isList: true,
                  structBuilder: D21MeditationModelStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: ConquistasPage.routeName,
              path: ConquistasPage.routePath,
              builder: (context, params) => const ConquistasPage(),
            ),
            // EAD Module Routes
            FFRoute(
              name: EadRoutes.eadHome,
              path: EadRoutes.eadHomePath,
              builder: (context, params) => const EadHomePage(),
            ),
            FFRoute(
              name: EadRoutes.catalogoCursos,
              path: EadRoutes.catalogoCursosPath,
              builder: (context, params) => const CatalogoCursosPage(),
            ),
            FFRoute(
              name: EadRoutes.cursoDetalhes,
              path: EadRoutes.cursoDetalhesPath,
              builder: (context, params) => CursoDetalhesPage(
                cursoId: params.getParam('cursoId', ParamType.String)!,
              ),
            ),
            FFRoute(
              name: EadRoutes.meusCursos,
              path: EadRoutes.meusCursosPath,
              builder: (context, params) => const MeusCursosPage(),
            ),
            FFRoute(
              name: EadRoutes.playerTopico,
              path: EadRoutes.playerTopicoPath,
              builder: (context, params) => PlayerTopicoPage(
                cursoId: params.getParam('cursoId', ParamType.String)!,
                aulaId: params.getParam('aulaId', ParamType.String)!,
                topicoId: params.getParam('topicoId', ParamType.String)!,
              ),
            ),
            FFRoute(
              name: EadRoutes.quiz,
              path: EadRoutes.quizPath,
              builder: (context, params) => QuizPage(
                cursoId: params.getParam('cursoId', ParamType.String)!,
                aulaId: params.getParam('aulaId', ParamType.String)!,
                topicoId: params.getParam('topicoId', ParamType.String)!,
              ),
            ),
            FFRoute(
              name: EadRoutes.certificado,
              path: EadRoutes.certificadoPath,
              builder: (context, params) => CertificadoPage(
                cursoId: params.getParam('cursoId', ParamType.String)!,
              ),
            ),
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect ? null : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) => !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) => appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap => extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty || (state.allParams.length == 1 && state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) => asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value).onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/sociallLogin';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          
          // Use AnimatedBuilder to listen to appStateNotifier changes for BOTH splash AND auth state
          return MaterialPage(
            key: state.pageKey,
            child: AnimatedBuilder(
              animation: appStateNotifier,
              builder: (context, _) {
                // Determine which page to show based on current auth state
                Widget currentPage;
                if (state.uri.path == '/') {
                  // Root path - decide between NavBarPage and SocialLoginPage
                  currentPage = appStateNotifier.loggedIn 
                      ? const NavBarPage() 
                      : const SocialLoginPage();
                } else {
                  // Other paths - use the builder
                  currentPage = ffParams.hasFutures
                      ? FutureBuilder(
                          future: ffParams.completeFutures(),
                          builder: (context, _) => builder(context, ffParams),
                        )
                      : builder(context, ffParams);
                }
                
                final basePage = PushNotificationsHandler(child: currentPage);
                
                Widget child;
                if (appStateNotifier.loading && !isWeb) {
                  child = Stack(
                    children: [
                      basePage,
                      Container(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo_meditabk.png',
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            height: MediaQuery.sizeOf(context).height * 1.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  child = basePage;
                }
                return child;
              },
            ),
          );
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage && location != '/' && location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

class FFExtraCodec extends Codec<Object?, Object?> {
  const FFExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _FFExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _FFExtraEncoder();
}

class _FFExtraEncoder extends Converter<Object?, Object?> {
  const _FFExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    if (input is List) {
      return input.map(convert).toList();
    }
    if (input is Map) {
      return input.map((k, v) => MapEntry(k, convert(v)));
    }
    if (input is String || input is num || input is bool) {
      return input;
    }
    return null;
  }
}

class _FFExtraDecoder extends Converter<Object?, Object?> {
  const _FFExtraDecoder();

  @override
  Object? convert(Object? input) {
    return input;
  }
}
