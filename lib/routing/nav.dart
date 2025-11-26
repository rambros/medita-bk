import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/structs/util/schema_util.dart';
import '/core/structs/d21_meditation_model_struct.dart';

import '/data/services/auth/base_auth_user_provider.dart';

import '/data/services/push_notifications/push_notifications_handler.dart' show PushNotificationsHandler;
import '/index.dart';
import '/main.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
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
              name: EditProfilePageWidget.routeName,
              path: EditProfilePageWidget.routePath,
              builder: (context, params) => const EditProfilePageWidget(),
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
              name: ProfilePageWidget.routeName,
              path: ProfilePageWidget.routePath,
              builder: (context, params) => const ProfilePageWidget(),
            ),
            FFRoute(
              name: MeditationHomePageWidget.routeName,
              path: MeditationHomePageWidget.routePath,
              builder: (context, params) => params.isEmpty
                  ? const NavBarPage(initialPage: 'meditationHomePage')
                  : const MeditationHomePageWidget(),
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
              name: ConfigPageWidget.routeName,
              path: ConfigPageWidget.routePath,
              builder: (context, params) => const ConfigPageWidget(),
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
              name: AppReviewPageWidget.routeName,
              path: AppReviewPageWidget.routePath,
              builder: (context, params) => const AppReviewPageWidget(),
            ),
            FFRoute(
              name: SettingsPage.routeName,
              path: SettingsPage.routePath,
              builder: (context, params) => const SettingsPage(),
            ),
            FFRoute(
              name: InvitePageWidget.routeName,
              path: InvitePageWidget.routePath,
              builder: (context, params) => const InvitePageWidget(),
            ),
            FFRoute(
              name: DeleteAccountPage.routeName,
              path: DeleteAccountPage.routePath,
              builder: (context, params) => const DeleteAccountPage(),
            ),
            FFRoute(
              name: AboutAuthorsPageWidget.routeName,
              path: AboutAuthorsPageWidget.routePath,
              builder: (context, params) => const AboutAuthorsPageWidget(),
            ),
            FFRoute(
              name: AlarmPageWidget.routeName,
              path: AlarmPageWidget.routePath,
              builder: (context, params) => const AlarmPageWidget(),
            ),
            FFRoute(
              name: MeditationDetailsPageWidget.routeName,
              path: MeditationDetailsPageWidget.routePath,
              builder: (context, params) => MeditationDetailsPageWidget(
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
              name: MeditationPlayPageWidget.routeName,
              path: MeditationPlayPageWidget.routePath,
              builder: (context, params) => MeditationPlayPageWidget(
                meditationId: params.getParam(
                  'meditationId',
                  ParamType.String,
                  isList: false,
                )!,
              ),
            ),
            FFRoute(
              name: MeditationListPageWidget.routeName,
              path: MeditationListPageWidget.routePath,
              builder: (context, params) => const MeditationListPageWidget(),
            ),
            FFRoute(
              name: VideoHomePageWidget.routeName,
              path: VideoHomePageWidget.routePath,
              builder: (context, params) =>
                  params.isEmpty ? const NavBarPage(initialPage: 'videoHomePage') : const VideoHomePageWidget(),
            ),
            FFRoute(
              name: YoutubePlayerPageWidget.routeName,
              path: YoutubePlayerPageWidget.routePath,
              builder: (context, params) => YoutubePlayerPageWidget(
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
              name: CongressoListPageWidget.routeName,
              path: CongressoListPageWidget.routePath,
              builder: (context, params) => const CongressoListPageWidget(),
            ),
            FFRoute(
              name: EntrevistasListPageWidget.routeName,
              path: EntrevistasListPageWidget.routePath,
              builder: (context, params) => const EntrevistasListPageWidget(),
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
              name: MeditationStatisticsPageWidget.routeName,
              path: MeditationStatisticsPageWidget.routePath,
              builder: (context, params) => const MeditationStatisticsPageWidget(),
            ),
            FFRoute(
              name: PlaylistListPageWidget.routeName,
              path: PlaylistListPageWidget.routePath,
              builder: (context, params) => const PlaylistListPageWidget(),
            ),
            FFRoute(
              name: PlaylistDetailsPageWidget.routeName,
              path: PlaylistDetailsPageWidget.routePath,
              builder: (context, params) => PlaylistDetailsPageWidget(
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
              name: PlaylistAddAudiosPageWidget.routeName,
              path: PlaylistAddAudiosPageWidget.routePath,
              builder: (context, params) => const PlaylistAddAudiosPageWidget(),
            ),
            FFRoute(
              name: SelectinstrumentPageWidget.routeName,
              path: SelectinstrumentPageWidget.routePath,
              builder: (context, params) => const SelectinstrumentPageWidget(),
            ),
            FFRoute(
              name: SelectMusicPageWidget.routeName,
              path: SelectMusicPageWidget.routePath,
              builder: (context, params) => const SelectMusicPageWidget(),
            ),
            FFRoute(
              name: SelectMeditationsPageWidget.routeName,
              path: SelectMeditationsPageWidget.routePath,
              builder: (context, params) => const SelectMeditationsPageWidget(),
            ),
            FFRoute(
              name: SelectDeviceMusicPageWidget.routeName,
              path: SelectDeviceMusicPageWidget.routePath,
              builder: (context, params) => const SelectDeviceMusicPageWidget(),
            ),
            FFRoute(
              name: PlaylistSavePageWidget.routeName,
              path: PlaylistSavePageWidget.routePath,
              builder: (context, params) => const PlaylistSavePageWidget(),
            ),
            FFRoute(
              name: PlaylistEditPageWidget.routeName,
              path: PlaylistEditPageWidget.routePath,
              builder: (context, params) => PlaylistEditPageWidget(
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
              name: PlaylistEditAudiosPageWidget.routeName,
              path: PlaylistEditAudiosPageWidget.routePath,
              builder: (context, params) => PlaylistEditAudiosPageWidget(
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
              name: CanalViverListPageWidget.routeName,
              path: CanalViverListPageWidget.routePath,
              builder: (context, params) => const CanalViverListPageWidget(),
            ),
            FFRoute(
              name: PalestrasListPageWidget.routeName,
              path: PalestrasListPageWidget.routePath,
              builder: (context, params) => const PalestrasListPageWidget(),
            ),
            FFRoute(
              name: SupportPageWidget.routeName,
              path: SupportPageWidget.routePath,
              builder: (context, params) => const SupportPageWidget(),
            ),
            FFRoute(
              name: FeedbackPageWidget.routeName,
              path: FeedbackPageWidget.routePath,
              builder: (context, params) => const FeedbackPageWidget(),
            ),
            FFRoute(
              name: FeaturePageWidget.routeName,
              path: FeaturePageWidget.routePath,
              builder: (context, params) => const FeaturePageWidget(),
            ),
            FFRoute(
              name: DonationPageWidget.routeName,
              path: DonationPageWidget.routePath,
              builder: (context, params) => const DonationPageWidget(),
            ),
            FFRoute(
              name: PlaylistPlayPageWidget.routeName,
              path: PlaylistPlayPageWidget.routePath,
              builder: (context, params) => const PlaylistPlayPageWidget(),
            ),
            FFRoute(
              name: PlaylistAudioPlayPageWidget.routeName,
              path: PlaylistAudioPlayPageWidget.routePath,
              builder: (context, params) => PlaylistAudioPlayPageWidget(
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
            )
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
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
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
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
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
