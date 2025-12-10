import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'title_page_model.dart';
export 'title_page_model.dart';

class TitlePageWidget extends StatefulWidget {
  const TitlePageWidget({super.key});

  @override
  State<TitlePageWidget> createState() => _TitlePageWidgetState();
}

class _TitlePageWidgetState extends State<TitlePageWidget> {
  late TitlePageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TitlePageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FFButtonWidget(
          onPressed: () async {
            context.safePop();
          },
          text: 'Return',
          icon: const Icon(
            Icons.arrow_back,
            size: 15.0,
          ),
          options: FFButtonOptions(
            width: 130.0,
            height: 40.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                  color: Colors.white,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                ),
            elevation: 2.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.6,
          height: 40.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Text(
            'Step Details',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
        ),
      ],
    );
  }
}
