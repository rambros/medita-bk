import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '/data/models/firebase/notification_model.dart';
import '/ui/core/flutter_flow/flutter_flow_animations.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/notification/widgets/notification_card.dart';
import 'view_model/notification_list_view_model.dart';

/// Notification list page with tabs
/// Displays all, scheduled, and sent notifications
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  static String routeName = 'notificationListPage';
  static String routePath = 'notificationListPage';

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'notificationListPage'});

    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() {
        if (mounted) {
          final viewModel = context.read<NotificationListViewModel>();
          viewModel.setTabIndex(_tabController.index);
        }
      });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(30.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationListViewModel>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Status bar spacer
                  if (responsiveVisibility(
                    context: context,
                    tabletLandscape: false,
                    desktop: false,
                  ))
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        alignment: const AlignmentDirectional(0.0, 0.0),
                      ),
                    ),

                  // Main content container
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 32.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: MediaQuery.sizeOf(context).height * 0.92,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x33000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: const AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(0.0),
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Notificações',
                                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                    fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                'Notificações enviadas para os usuários',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Tabs and content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: StreamBuilder<List<NotificationModel>>(
                                    stream: viewModel.getNotificationsForTab(),
                                    builder: (context, snapshot) {
                                      // Loading state
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context).primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final notifications = snapshot.data!;

                                      return Column(
                                        children: [
                                          // Tab Bar
                                          Align(
                                            alignment: const Alignment(0.0, 0),
                                            child: TabBar(
                                              labelColor: FlutterFlowTheme.of(context).primaryText,
                                              unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                                              labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                                    fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                                                  ),
                                              unselectedLabelStyle: const TextStyle(),
                                              indicatorColor: FlutterFlowTheme.of(context).primary,
                                              padding: const EdgeInsets.all(4.0),
                                              tabs: const [
                                                Tab(
                                                  text: 'Todas as Notifcações',
                                                ),
                                                Tab(
                                                  text: 'Notificações Agendadas',
                                                ),
                                                Tab(
                                                  text: 'Notificações Enviadas',
                                                ),
                                              ],
                                              controller: _tabController,
                                              onTap: (i) async {
                                                // Tab change is handled by listener
                                              },
                                            ),
                                          ),

                                          // Tab Content
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                // Tab 1: All Notifications
                                                _buildNotificationList(notifications),

                                                // Tab 2: Scheduled Notifications (placeholder)
                                                KeepAliveWidgetWrapper(
                                                  builder: (context) => Center(
                                                    child: Text(
                                                      'Notificações Agendadas',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                            fontSize: 32.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),

                                                // Tab 3: Sent Notifications (placeholder)
                                                KeepAliveWidgetWrapper(
                                                  builder: (context) => Center(
                                                    child: Text(
                                                      'Notificações Enviadas',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                            fontSize: 32.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build notification list widget
  Widget _buildNotificationList(List<NotificationModel> notifications) {
    return KeepAliveWidgetWrapper(
      builder: (context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.2,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              scrollDirection: Axis.vertical,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  animation: animationsMap['containerOnPageLoadAnimation'],
                  onTap: () {
                    // TODO: Open notification view dialog
                    // This will be implemented when we integrate NotificationViewPage
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
