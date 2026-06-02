import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:medita_bk/domain/models/ead/faq_model.dart';
import 'package:medita_bk/routing/ead_routes.dart';
import 'package:medita_bk/ui/core/theme/app_theme.dart';
import 'package:medita_bk/ui/suporte/faq/view_model/faq_view_model.dart';

class FaqListPage extends StatelessWidget {
  const FaqListPage({super.key});

  static const String routeName = EadRoutes.faq;
  static const String routePath = EadRoutes.faqPath;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FaqViewModel(),
      child: const _FaqListContent(),
    );
  }
}

class _FaqListContent extends StatelessWidget {
  const _FaqListContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FaqViewModel>();
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        foregroundColor: appTheme.info,
        title: Text(
          'Perguntas Frequentes',
          style: TextStyle(color: appTheme.info),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(context, vm, appTheme),
    );
  }

  Widget _buildBody(BuildContext context, FaqViewModel vm, AppTheme appTheme) {
    if (vm.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: appTheme.primary),
      );
    }

    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 56, color: appTheme.error),
              const SizedBox(height: 16),
              Text(vm.error!, textAlign: TextAlign.center, style: TextStyle(color: appTheme.primaryText)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: vm.refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(backgroundColor: appTheme.primary, foregroundColor: appTheme.info),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.faqs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.help_outline, size: 64, color: appTheme.secondaryText),
              const SizedBox(height: 16),
              Text(
                'Nenhuma pergunta disponível no momento.',
                textAlign: TextAlign.center,
                style: TextStyle(color: appTheme.secondaryText, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => vm.refresh(),
      color: appTheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: vm.secoes.length,
        itemBuilder: (context, index) {
          final secao = vm.secoes[index];
          final itens = vm.faqsPorSecao(secao);
          return _SecaoExpansao(secao: secao, itens: itens);
        },
      ),
    );
  }
}

class _SecaoExpansao extends StatelessWidget {
  const _SecaoExpansao({required this.secao, required this.itens});

  final String secao;
  final List<FaqModel> itens;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: appTheme.secondaryBackground,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: appTheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.folder_outlined, color: appTheme.primary, size: 18),
        ),
        title: Text(
          secao,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: appTheme.primaryText,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          '${itens.length} ${itens.length == 1 ? 'pergunta' : 'perguntas'}',
          style: TextStyle(color: appTheme.secondaryText, fontSize: 12),
        ),
        iconColor: appTheme.primary,
        collapsedIconColor: appTheme.secondaryText,
        children: itens.map((faq) => _FaqItem(faq: faq)).toList(),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.faq});

  final FaqModel faq;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      children: [
        const Divider(height: 1, indent: 16, endIndent: 16),
        ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          leading: Icon(Icons.help_outline, color: appTheme.primary, size: 18),
          title: Text(
            faq.pergunta,
            style: TextStyle(
              color: appTheme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: appTheme.primary,
          collapsedIconColor: appTheme.secondaryText,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: appTheme.primaryBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                faq.resposta,
                style: TextStyle(
                  color: appTheme.primaryText,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
