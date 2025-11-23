import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/push_notifications/push_notifications_util.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

import '/data/repositories/agenda_repository.dart';
import '/ui/agenda/agenda_home_page/view_model/agenda_home_view_model.dart';
import '/ui/agenda/agenda_list_page/view_model/agenda_list_view_model.dart';
import '/ui/agenda/event_list_page/view_model/event_list_view_model.dart';
import '/ui/agenda/event_details_page/view_model/event_details_view_model.dart';
import '/ui/agenda/agenda_home_page/agenda_home_page.dart';

import '/data/repositories/video_repository.dart';
import '/ui/video/video_home_page/view_model/video_home_view_model.dart';
import '/ui/video/palestras_list_page/view_model/palestras_list_view_model.dart';
import '/ui/video/congresso_list_page/view_model/congresso_list_view_model.dart';
import '/ui/video/entrevistas_list_page/view_model/entrevistas_list_view_model.dart';
import '/ui/video/canal_viver_list_page/view_model/canal_viver_list_view_model.dart';
import '/ui/video/youtube_player_page/view_model/youtube_player_view_model.dart';

import '/data/repositories/user_repository.dart';
import '/ui/config/about_authors_page/view_model/about_authors_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Start initial custom actions code
  await actions.initializeNotificationPlugin();
  // End initial custom actions code

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // Start final custom actions code
  await actions.initAudioService();
  await actions.initAudioPlayerController();
  // End final custom actions code

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
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
      // User Repository and ViewModels
      Provider(create: (_) => UserRepository()),
      ChangeNotifierProxyProvider<UserRepository, AboutAuthorsViewModel>(
        create: (context) => AboutAuthorsViewModel(repository: context.read<UserRepository>()),
        update: (context, repo, viewModel) => viewModel ?? AboutAuthorsViewModel(repository: repo),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
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
      scrollBehavior: MyAppScrollBehavior(),
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
      'homePage': const HomePageWidget(),
      'mensagensHomePage': const MensagensHomePageWidget(),
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
