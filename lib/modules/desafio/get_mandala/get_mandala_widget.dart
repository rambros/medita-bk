import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'get_mandala_model.dart';
export 'get_mandala_model.dart';

class GetMandalaWidget extends StatefulWidget {
  const GetMandalaWidget({
    super.key,
    int? etapa,
    required this.listaEtapasMandalas,
    int? diaCompletado,
  })  : etapa = etapa ?? 0,
        diaCompletado = diaCompletado ?? 0;

  final int etapa;
  final List<D21EtapaModelStruct>? listaEtapasMandalas;
  final int diaCompletado;

  @override
  State<GetMandalaWidget> createState() => _GetMandalaWidgetState();
}

class _GetMandalaWidgetState extends State<GetMandalaWidget> {
  late GetMandalaModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GetMandalaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              functions.getURLMandala(widget.etapa, widget.diaCompletado,
                  widget.listaEtapasMandalas!.toList())!,
              width: MediaQuery.sizeOf(context).width * 2.0,
              height: 200.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
