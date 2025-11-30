import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app_state.dart';
import '../../../routing/ead_routes.dart';
import 'view_model/certificado_view_model.dart';
import 'widgets/certificado_widget.dart';

/// Pagina de exibicao do certificado
class CertificadoPage extends StatefulWidget {
  const CertificadoPage({
    super.key,
    required this.cursoId,
  });

  final String cursoId;

  static const String routeName = EadRoutes.certificado;
  static const String routePath = EadRoutes.certificadoPath;

  @override
  State<CertificadoPage> createState() => _CertificadoPageState();
}

class _CertificadoPageState extends State<CertificadoPage> {
  late final CertificadoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CertificadoViewModel(cursoId: widget.cursoId);
    _carregarDados();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String? get _usuarioId => FFAppState().currentUser?.uid;

  Future<void> _carregarDados() async {
    final usuarioId = _usuarioId;
    if (usuarioId != null) {
      await _viewModel.carregarDados(usuarioId);
    }
  }

  void _compartilhar() {
    final texto = '''
🎓 Certificado de Conclusao

${_viewModel.nomeAluno} concluiu o curso "${_viewModel.tituloCurso}"

📅 Data: ${_viewModel.dataConclusaoFormatada}
📝 Codigo: ${_viewModel.codigoCertificado}
''';

    Share.share(texto, subject: 'Certificado - ${_viewModel.tituloCurso}');
  }

  void _baixarPdf() {
    // TODO: Implementar geracao de PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade em desenvolvimento'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_usuarioId == null) {
      return _buildNaoLogado();
    }

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Certificado'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _compartilhar,
              tooltip: 'Compartilhar',
            ),
          ],
        ),
        body: Consumer<CertificadoViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _buildError(viewModel);
            }

            if (!viewModel.certificadoDisponivel) {
              return _buildCertificadoIndisponivel();
            }

            return _buildConteudo(viewModel);
          },
        ),
      ),
    );
  }

  Widget _buildNaoLogado() {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Faca login para ver seu certificado',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(CertificadoViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _carregarDados,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificadoIndisponivel() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Certificado nao disponivel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Conclua o curso para obter seu certificado',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Voltar ao curso'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo(CertificadoViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Certificado visual
                CertificadoWidget(
                  nomeAluno: viewModel.nomeAluno,
                  tituloCurso: viewModel.tituloCurso,
                  nomeInstrutor: viewModel.nomeInstrutor,
                  dataConclusao: viewModel.dataConclusaoFormatada,
                  cargaHoraria: viewModel.cargaHoraria,
                  codigoCertificado: viewModel.codigoCertificado,
                ),

                // Detalhes
                _buildDetalhes(viewModel),
              ],
            ),
          ),
        ),

        // Botoes de acao
        CertificadoActions(
          onCompartilhar: _compartilhar,
          onBaixar: _baixarPdf,
        ),
      ],
    );
  }

  Widget _buildDetalhes(CertificadoViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes do curso',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _DetalheItem(
                icon: Icons.school,
                label: 'Curso',
                valor: viewModel.tituloCurso,
              ),
              _DetalheItem(
                icon: Icons.person,
                label: 'Instrutor',
                valor: viewModel.nomeInstrutor,
              ),
              _DetalheItem(
                icon: Icons.play_lesson,
                label: 'Total de aulas',
                valor: '${viewModel.totalAulas} aulas',
              ),
              _DetalheItem(
                icon: Icons.check_circle,
                label: 'Topicos concluidos',
                valor: '${viewModel.totalTopicos} topicos',
              ),
              if (viewModel.cargaHoraria.isNotEmpty)
                _DetalheItem(
                  icon: Icons.schedule,
                  label: 'Carga horaria',
                  valor: viewModel.cargaHoraria,
                ),
              _DetalheItem(
                icon: Icons.calendar_today,
                label: 'Concluido em',
                valor: viewModel.dataConclusaoFormatada,
              ),
              _DetalheItem(
                icon: Icons.tag,
                label: 'Codigo',
                valor: viewModel.codigoCertificado,
                isMonospace: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetalheItem extends StatelessWidget {
  const _DetalheItem({
    required this.icon,
    required this.label,
    required this.valor,
    this.isMonospace = false,
  });

  final IconData icon;
  final String label;
  final String valor;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    if (valor.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
                Text(
                  valor,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: isMonospace ? 'monospace' : null,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
