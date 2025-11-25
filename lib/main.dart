import '/core/services/audio_service.dart';
import '/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'data/services/auth/firebase_auth/firebase_user_provider.dart';
import 'data/services/auth/firebase_auth/auth_util.dart';

import 'backend/push_notifications/push_notifications_util.dart';
import 'backend/firebase/firebase_config.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'index.dart';
import '/core/controllers/index.dart';

import 'dart:ui' as ui;

import '/data/repositories/home_repository.dart';
import '/ui/home/home_page/view_model/home_view_model.dart';

import '/data/repositories/notification_repository.dart';
import '/ui/notification/notification_list_page/view_model/notification_list_view_model.dart';
import '/ui/notification/notification_view_page/view_model/notification_view_view_model.dart';

import '/data/repositories/agenda_repository.dart';
import '/ui/agenda/agenda_home_page/view_model/agenda_home_view_model.dart';
import '/ui/agenda/agenda_list_page/view_model/agenda_list_view_model.dart';
import '/ui/agenda/event_list_page/view_model/event_list_view_model.dart';
import '/ui/agenda/event_details_page/view_model/event_details_view_model.dart';
import '/data/repositories/mensagem_repository.dart';
import '/ui/mensagens/mensagem_details_page/view_model/mensagem_details_view_model.dart';
import '/ui/mensagens/mensagem_show_page/view_model/mensagem_show_view_model.dart';
import '/ui/mensagens/mensagens_semantic_search_page/view_model/mensagens_semantic_search_view_model.dart';

import '/data/repositories/video_repository.dart';
import '/ui/video/video_home_page/view_model/video_home_view_model.dart';
import '/ui/video/palestras_list_page/view_model/palestras_list_view_model.dart';
import '/ui/video/congresso_list_page/view_model/congresso_list_view_model.dart';
import '/ui/video/entrevistas_list_page/view_model/entrevistas_list_view_model.dart';
import '/ui/video/canal_viver_list_page/view_model/canal_viver_list_view_model.dart';
import '/ui/video/youtube_player_page/view_model/youtube_player_view_model.dart';

import '/backend/repositories/meditation/meditation_repository.dart';
import '/ui/meditation/meditation_home_page/view_model/meditation_home_view_model.dart';
import '/ui/meditation/meditation_list_page/view_model/meditation_list_view_model.dart';
import '/data/repositories/playlist_repository.dart';

import 'data/repositories/user_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/config/about_authors_page/view_model/about_authors_view_model.dart';
import 'ui/config/config_page/view_model/config_view_model.dart';
import 'package:medita_b_k/ui/config/edit_profile_page/view_model/edit_profile_view_model.dart';
import 'package:medita_b_k/ui/config/settings_page/view_model/settings_view_model.dart';
import 'package:medita_b_k/ui/config/delete_account_page/view_model/delete_account_view_model.dart';
import '/ui/authentication/sign_in/view_model/sign_in_view_model.dart';
import '/ui/authentication/sign_up/view_model/sign_up_view_model.dart';
import '/ui/authentication/forgot_password/view_model/forgot_password_view_model.dart';
import '/ui/authentication/change_email_page/view_model/change_email_view_model.dart';
import '/ui/authentication/social_login/view_model/social_login_view_model.dart';

import '/data/repositories/desafio_repository.dart';
import '/ui/desafio/home_desafio_page/view_model/home_desafio_view_model.dart';
import '/ui/desafio/lista_etapas_page/view_model/lista_etapas_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Initialize services
  await MeditaBKAudioService.initialize();
  final notificationService = NotificationService();
  await notificationService.initialize();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState(); // Initialize SharedPreferences
  await initAudioPlayerController();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),

      // Playlist Module
      Provider(create: (_) => PlaylistRepository()),

      // Home Module
      Provider(create: (_) => HomeRepository()),
      ChangeNotifierProxyProvider<HomeRepository, HomeViewModel>(
        create: (context) => HomeViewModel(context.read<HomeRepository>()),
        update: (context, repo, viewModel) => viewModel ?? HomeViewModel(repo),
      ),

      // Desafio Module
      Provider(create: (_) => DesafioRepository()),
      ChangeNotifierProxyProvider<DesafioRepository, HomeDesafioViewModel>(
        create: (context) => HomeDesafioViewModel(repository: context.read<DesafioRepository>()),
        update: (context, repo, viewModel) => viewModel ?? HomeDesafioViewModel(repository: repo),
      ),
      ChangeNotifierProvider(create: (_) => ListaEtapasViewModel()),

      // Notification Module
      Provider(create: (_) => NotificationRepository()),
      ChangeNotifierProxyProvider<NotificationRepository, NotificationListViewModel>(
        create: (context) => NotificationListViewModel(context.read<NotificationRepository>()),
        update: (context, repo, viewModel) => viewModel ?? NotificationListViewModel(repo),
      ),
      ChangeNotifierProvider(create: (_) => NotificationViewViewModel()),

      // Agenda Module
      Provider(create: (_) => AgendaRepository()),
      ChangeNotifierProvider(create: (_) => AgendaHomeViewModel()),
      ChangeNotifierProxyProvider<AgendaRepository, AgendaListViewModel>(
        create: (context) => AgendaListViewModel(repository: context.read<AgendaRepository>()),
        update: (context, repo, viewModel) => viewModel ?? AgendaListViewModel(repository: repo),
      ),
      ChangeNotifierProxyProvider<AgendaRepository, EventListViewModel>(
        create: (context) => EventListViewModel(repository: context.read<AgendaRepository>()),
        update: (context, repo, viewModel) => viewModel ?? EventListViewModel(repository: repo),
      ),
      ChangeNotifierProvider(create: (_) => EventDetailsViewModel()),

      // Mensagens Module
      Provider(create: (_) => MensagemRepository()),
      ChangeNotifierProxyProvider<MensagemRepository, MensagemDetailsViewModel>(
        create: (context) => MensagemDetailsViewModel(context.read<MensagemRepository>()),
        update: (context, repo, viewModel) => viewModel ?? MensagemDetailsViewModel(repo),
      ),
      ChangeNotifierProvider(create: (_) => MensagemShowViewModel()),
      ChangeNotifierProxyProvider<MensagemRepository, MensagensSemanticSearchViewModel>(
        create: (context) => MensagensSemanticSearchViewModel(context.read<MensagemRepository>()),
        update: (context, repo, viewModel) => viewModel ?? MensagensSemanticSearchViewModel(repo),
      ),
      Provider(create: (_) => VideoRepository()),
      ChangeNotifierProxyProvider<VideoRepository, VideoHomeViewModel>(
        create: (context) => VideoHomeViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? VideoHomeViewModel(repo),
      ),
      ChangeNotifierProxyProvider<VideoRepository, PalestrasListViewModel>(
        create: (context) => PalestrasListViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? PalestrasListViewModel(repo),
      ),
      ChangeNotifierProxyProvider<VideoRepository, CongressoListViewModel>(
        create: (context) => CongressoListViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? CongressoListViewModel(repo),
      ),
      ChangeNotifierProxyProvider<VideoRepository, EntrevistasListViewModel>(
        create: (context) => EntrevistasListViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? EntrevistasListViewModel(repo),
      ),
      ChangeNotifierProxyProvider<VideoRepository, CanalViverListViewModel>(
        create: (context) => CanalViverListViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? CanalViverListViewModel(repo),
      ),
      ChangeNotifierProxyProvider<VideoRepository, YoutubePlayerViewModel>(
        create: (context) => YoutubePlayerViewModel(context.read<VideoRepository>()),
        update: (context, repo, viewModel) => viewModel ?? YoutubePlayerViewModel(repo),
      ),

      // Meditation Module
      Provider<MeditationRepository>(create: (_) => MeditationRepositoryImpl()),
      ChangeNotifierProvider(create: (_) => MeditationHomeViewModel()),
      ChangeNotifierProxyProvider<MeditationRepository, MeditationListViewModel>(
        create: (context) => MeditationListViewModel(meditationRepository: context.read<MeditationRepository>()),
        update: (context, repo, viewModel) => viewModel ?? MeditationListViewModel(meditationRepository: repo),
      ),
      // User Repository and ViewModels
      Provider(create: (context) => UserRepository()),
      Provider(create: (context) => AuthRepository()),
      ChangeNotifierProxyProvider<AuthRepository, ConfigViewModel>(
        create: (context) => ConfigViewModel(
          authRepository: Provider.of<AuthRepository>(context, listen: false),
        ),
        update: (context, authRepository, previous) => ConfigViewModel(authRepository: authRepository),
      ),
      ChangeNotifierProxyProvider<UserRepository, EditProfileViewModel>(
        create: (context) => EditProfileViewModel(
          userRepository: Provider.of<UserRepository>(context, listen: false),
        ),
        update: (context, userRepository, previous) => previous ?? EditProfileViewModel(userRepository: userRepository),
      ),
      ChangeNotifierProvider(create: (context) => SettingsViewModel()),
      ChangeNotifierProxyProvider<AuthRepository, DeleteAccountViewModel>(
        create: (context) =>
            DeleteAccountViewModel(authRepository: Provider.of<AuthRepository>(context, listen: false)),
        update: (context, authRepository, previous) =>
            previous ?? DeleteAccountViewModel(authRepository: authRepository),
      ),
      ChangeNotifierProxyProvider<UserRepository, AboutAuthorsViewModel>(
        create: (context) => AboutAuthorsViewModel(repository: context.read<UserRepository>()),
        update: (context, repo, viewModel) => viewModel ?? AboutAuthorsViewModel(repository: repo),
      ),
      // Authentication ViewModels
      ChangeNotifierProxyProvider<AuthRepository, SignInViewModel>(
        create: (context) => SignInViewModel(context.read<AuthRepository>()),
        update: (context, repo, viewModel) => viewModel ?? SignInViewModel(repo),
      ),
      ChangeNotifierProxyProvider2<AuthRepository, UserRepository, SignUpViewModel>(
        create: (context) => SignUpViewModel(
          context.read<AuthRepository>(),
          context.read<UserRepository>(),
        ),
        update: (context, authRepo, userRepo, viewModel) =>
            viewModel ??
            SignUpViewModel(
              authRepo,
              userRepo,
            ),
      ),
      ChangeNotifierProxyProvider<AuthRepository, ForgotPasswordViewModel>(
        create: (context) => ForgotPasswordViewModel(context.read<AuthRepository>()),
        update: (context, repo, viewModel) => viewModel ?? ForgotPasswordViewModel(repo),
      ),
      ChangeNotifierProxyProvider<AuthRepository, ChangeEmailViewModel>(
        create: (context) => ChangeEmailViewModel(context.read<AuthRepository>()),
        update: (context, repo, viewModel) => viewModel ?? ChangeEmailViewModel(repo),
      ),
      ChangeNotifierProxyProvider<AuthRepository, SocialLoginViewModel>(
        create: (context) => SocialLoginViewModel(context.read<AuthRepository>()),
        update: (context, repo, viewModel) => viewModel ?? SocialLoginViewModel(repo),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<ui.PointerDeviceKind> get dragDevices => {
        ui.PointerDeviceKind.touch,
        ui.PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() => _router.routerDelegate.currentConfiguration.matches.map((e) => getRoute(e)).toList();
  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});
  final fcmTokenSub = fcmTokenUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = meditaBKFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: isWeb ? 0 : 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();
    fcmTokenSub.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MeditaBK',
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'homePage';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'homePage': const HomePage(),
      'mensagensHomePage': const MensagensHomePage(),
      'meditationHomePage': const MeditationHomePageWidget(),
      'videoHomePage': const VideoHomePageWidget(),
      'agendaHomePage': const AgendaHomePage(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Visibility(
        visible: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => safeSetState(() {
            _currentPage = null;
            _currentPageName = tabs.keys.toList()[i];
          }),
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 24.0,
              ),
              label: 'Início',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FFIcons.karticleBlack24dp,
                size: 28.0,
              ),
              label: 'Mensagens',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FFIcons.kyogaPosition,
                size: 30.0,
              ),
              label: 'Meditações',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FFIcons.kchalkboardTeacher,
                size: 24.0,
              ),
              label: 'Vídeos',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FFIcons.kcalendarMonthBlack24dp,
                size: 28.0,
              ),
              label: 'Agenda',
              tooltip: '',
            )
          ],
        ),
      ),
    );
  }
}
