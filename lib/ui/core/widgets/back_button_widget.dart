import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_theme.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'back_button_model.dart';
export 'back_button_model.dart';

class BackButtonWidget extends StatefulWidget {
  const BackButtonWidget({super.key});

  @override
  State<BackButtonWidget> createState() => _BackButtonWidgetState();
}

class _BackButtonWidgetState extends State<BackButtonWidget> {
  late BackButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BackButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 16.0, 16.0),
      child: Container(
        width: 100.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: FFButtonWidget(
          onPressed: () async {
            context.safePop();
          },
          text: '',
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 36.0,
          ),
          options: FFButtonOptions(
            width: 20.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconColor: FlutterFlowTheme.of(context).primaryText,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                  color: Colors.white,
                  letterSpacing: 0.0,
                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                ),
            elevation: 0.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
