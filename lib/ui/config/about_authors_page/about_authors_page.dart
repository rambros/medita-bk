import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'view_model/about_authors_view_model.dart';

class AboutAuthorsPageWidget extends StatefulWidget {
  const AboutAuthorsPageWidget({super.key});

  static String routeName = 'aboutAuthorsPage';
  static String routePath = 'aboutAuthorsPage';

  @override
  State<AboutAuthorsPageWidget> createState() => _AboutAuthorsPageWidgetState();
}

class _AboutAuthorsPageWidgetState extends State<AboutAuthorsPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'aboutAuthorsPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Autores',
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
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Consumer<AboutAuthorsViewModel>(
            builder: (context, viewModel, child) {
              return PagedListView<DocumentSnapshot?, UsersRecord>.separated(
                pagingController: viewModel.pagingController,
                padding: EdgeInsets.zero,
                reverse: false,
                scrollDirection: Axis.vertical,
                separatorBuilder: (_, __) => const SizedBox(height: 4.0),
                builderDelegate: PagedChildBuilderDelegate<UsersRecord>(
                  // Customize what your widget looks like when it's loading the first page.
                  firstPageProgressIndicatorBuilder: (_) => Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                  // Customize what your widget looks like when it's loading another page.
                  newPageProgressIndicatorBuilder: (_) => Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, _, listViewIndex) {
                    final listViewUsersRecord = viewModel.pagingController.itemList![listViewIndex];
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          // TODO: Navigate to author detail page or show author info
                          // For now, showing a placeholder message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Detalhes de ${listViewUsersRecord.fullName}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Container(
                                  width: 90.0,
                                  height: 90.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      listViewUsersRecord.userImageUrl,
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listViewUsersRecord.fullName,
                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                          ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 68.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                      ),
                                      child: Text(
                                        listViewUsersRecord.curriculum,
                                        textAlign: TextAlign.start,
                                        maxLines: 4,
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                            ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(height: 4.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
