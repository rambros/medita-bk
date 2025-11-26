import 'package:flutter/material.dart';

import '/core/structs/index.dart';
import '/ui/core/flutter_flow/custom_functions.dart' as functions;
import '/ui/core/flutter_flow/flutter_flow_theme.dart';

class GetMandalaWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final mandalaUrl = listaEtapasMandalas == null
        ? null
        : functions.getURLMandala(etapa, diaCompletado, listaEtapasMandalas!.toList());

    if (mandalaUrl == null) {
      return Text(
        'Mandala não encontrada',
        style: FlutterFlowTheme.of(context).bodyMedium,
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          mandalaUrl,
          width: MediaQuery.sizeOf(context).width * 2.0,
          height: 200.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
