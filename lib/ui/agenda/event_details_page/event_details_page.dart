import '/ui/core/flutter_flow/flutter_flow_icon_button.dart';
import '/ui/core/flutter_flow/flutter_flow_theme.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/ui/core/widgets/html_display_widget.dart';
import 'package:flutter/material.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    super.key,
    required this.eventDoc,
  });

  final dynamic eventDoc;

  static String routeName = 'eventDetailsPage';
  static String routePath = 'eventDetailsPage';

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'eventDetailsPage'});

    // Initialize ViewModel with passed data
    // Note: In a real app, we might fetch fresh data by ID, but here we use passed data
    // We need to cast dynamic eventDoc to EventModelStruct if possible, or handle it in ViewModel
    // For this refactoring, we'll assume eventDoc is passed correctly.
    // Since the original code used dynamic, we'll keep it flexible but ideally should be typed.
  }

  @override
  Widget build(BuildContext context) {
    // We can use the ViewModel to hold the event data if we want to support editing or refreshing
    // For now, we'll just display the data passed in the widget, but we set it in VM for consistency
    // context.read<EventDetailsViewModel>().setEvent(widget.eventDoc);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).info,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                title: Text(
                  'Detalhes do Evento',
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
                actions: const [],
                centerTitle: true,
                elevation: 2.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      getJsonField(
                        widget.eventDoc,
                        r'''$.name''',
                      ).toString(),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context).titleMediumIsCustom,
                          ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                    child: HtmlDisplayWidget(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      description: getJsonField(
                        widget.eventDoc,
                        r'''$.description''',
                      ).toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
