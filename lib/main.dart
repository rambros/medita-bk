import 'package:medita_b_k/core/services/audio_service.dart';
import 'package:medita_b_k/core/services/notification_service.dart';
import 'package:medita_b_k/data/services/badge_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'data/services/auth/firebase_auth/firebase_user_provider.dart';
import 'data/services/auth/firebase_auth/auth_util.dart';

import 'data/services/push_notifications/push_notifications_util.dart';
import 'data/services/firebase_config.dart';
import 'package:medita_b_k/ui/core/theme/app_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/ui/core/flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:medita_b_k/ui/pages.dart';
import 'package:medita_b_k/core/controllers/index.dart';

import 'dart:ui' as ui;

import 'package:medita_b_k/data/repositories/index.dart';
import 'package:medita_b_k/ui/view_models.dart';
import 'package:medita_b_k/data/services/auth/firebase_auth/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Força o app a ficar em modo portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Initialize services
  await MeditaBKAudioService.initialize();
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize badge service for notifications counter
  final badgeService = BadgeService();
  await badgeService.initialize();

  await AppTheme.initialize();

  final appState = AppStateStore(); // Initialize AppStateStore
  await appState.initializePersistedState(); // Initialize SharedPreferences
  await initAudioPlayerController();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),

      // Core services
      Provider(create: (_) => FirebaseAuthService()),
      ProxyProvider<FirebaseAuthService, AuthRepository>(
        update: (context, authService, previous) => previous ?? AuthRepository(authService: authService),
      ),
      Provider(create: (_) => UserRepository()),
      Provider(create: (_) => CategoryRepository()),
      Provider(create: (_) => NotificacoesRepository()),

      // Playlist Module
      Provider(create: (_) => PlaylistRepository()),

      // Home Module
      Provider(create: (_) => HomeRepository()),
      ChangeNotifierProxyProvider2<HomeRepository, AuthRepository, HomeViewModel>(
        create: (context) => HomeViewModel(
          repository: context.read<HomeRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        update: (context, homeRepo, authRepo, viewModel) =>
            viewModel ?? HomeViewModel(repository: homeRepo, authRepository: authRepo),
      ),

      // Desafio Module
      Provider(create: (_) => DesafioRepository()),
      ChangeNotifierProxyProvider2<DesafioRepository, AuthRepository, HomeDesafioViewModel>(
        create: (context) => HomeDesafioViewModel(
          repository: context.read<DesafioRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        update: (context, repo, authRepo, viewModel) =>
            viewModel ?? HomeDesafioViewModel(repository: repo, authRepository: authRepo),
      ),
      ChangeNotifierProxyProvider2<DesafioRepository, AuthRepository, ListaEtapasViewModel>(
        create: (context) => ListaEtapasViewModel(
          authRepository: context.read<AuthRepository>(),
          repository: context.read<DesafioRepository>(),
        ),
        update: (context, repo, authRepo, previous) =>
            previous ?? ListaEtapasViewModel(authRepository: authRepo, repository: repo),
      ),

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

      // Music Module
      Provider(create: (_) => MusicRepository()),

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
      ChangeNotifierProxyProvider2<MeditationRepository, AuthRepository, MeditationListViewModel>(
        create: (context) => MeditationListViewModel(
          meditationRepository: context.read<MeditationRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        update: (context, medRepo, authRepo, viewModel) =>
            viewModel ?? MeditationListViewModel(meditationRepository: medRepo, authRepository: authRepo),
      ),
      // User Repository and ViewModels
      ChangeNotifierProxyProvider2<AuthRepository, UserRepository, ConfigViewModel>(
        create: (context) => ConfigViewModel(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        update: (context, authRepository, userRepository, previous) =>
            previous ?? ConfigViewModel(authRepository: authRepository, userRepository: userRepository),
      ),
      ChangeNotifierProxyProvider2<AuthRepository, UserRepository, EditProfileViewModel>(
        create: (context) => EditProfileViewModel(
          userRepository: Provider.of<UserRepository>(context, listen: false),
          authRepository: Provider.of<AuthRepository>(context, listen: false),
        ),
        update: (context, authRepository, userRepository, previous) =>
            previous ?? EditProfileViewModel(userRepository: userRepository, authRepository: authRepository),
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

  ThemeMode _themeMode = AppTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatchBase? routeMatch]) {
    final RouteMatchBase lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
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
    
    // Setup user stream with error handling
    try {
      userStream = meditaBKFirebaseUserStream()
        ..listen(
          (user) {
            _appStateNotifier.update(user);
          },
          onError: (error) {
            // Force hide splash on error to prevent getting stuck
            _appStateNotifier.stopShowingSplashImage();
          },
        );
      
      jwtTokenStream.listen((_) {});
    } catch (e) {
      _appStateNotifier.stopShowingSplashImage();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appStateNotifier.stopShowingSplashImage();
    });
    Future.delayed(
      Duration(milliseconds: isWeb ? 0 : 1000),
      () {
        _appStateNotifier.stopShowingSplashImage();
      },
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
        AppTheme.saveThemeMode(mode);
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
      'meditationHomePage': const MeditationHomePage(),
      'videoHomePage': const VideoHomePage(),
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
          backgroundColor: AppTheme.of(context).primaryBackground,
          selectedItemColor: AppTheme.of(context).primary,
          unselectedItemColor: AppTheme.of(context).secondaryText,
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
