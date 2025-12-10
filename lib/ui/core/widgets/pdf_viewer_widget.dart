import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:medita_b_k/ui/core/theme/app_theme.dart';

/// Widget para visualizar arquivos PDF
/// Suporta zoom (pinch e scroll), navegação entre páginas e download
class PdfViewerWidget extends StatefulWidget {
  const PdfViewerWidget({
    super.key,
    required this.pdfUrl,
    this.title,
    this.showDownloadButton = true,
  });

  final String pdfUrl;
  final String? title;
  final bool showDownloadButton;

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _initPdfController();
  }

  /// Corrige URLs incompletas do Firebase Storage
  String _fixFirebaseStorageUrl(String url) {
    // Se a URL já está completa, retorna ela mesma
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    
    // Se está com encoding (%2F) mas sem domínio, é uma URL do Firebase Storage incompleta
    // Exemplo: ead%2Fpdfs%2Ffile.pdf?alt=media&token=...
    // Precisamos adicionar o prefixo do Firebase Storage
    if (url.contains('%2F') || url.contains('alt=media')) {
      // Remove a barra inicial se houver
      final cleanUrl = url.startsWith('/') ? url.substring(1) : url;
      
      // Constrói a URL completa do Firebase Storage
      return 'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/$cleanUrl';
    }
    
    // Se não tem protocolo mas parece um path, assume Firebase Storage
    final encodedPath = Uri.encodeComponent(url);
    return 'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/$encodedPath?alt=media';
  }

  /// Faz o download dos dados do PDF a partir da URL
  Future<Uint8List> _downloadPdfData(String url) async {
    final fixedUrl = _fixFirebaseStorageUrl(url);
    final response = await http.get(Uri.parse(fixedUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Falha ao baixar PDF: ${response.statusCode}');
    }
  }

  Future<void> _initPdfController() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final controller = PdfControllerPinch(
        document: PdfDocument.openData(
          // Usa a função de download assíncrona do pdfx
          _downloadPdfData(widget.pdfUrl),
        ),
      );

      // Aguarda o documento carregar para obter o total de páginas
      final document = await controller.document;
      final pagesCount = document.pagesCount;

      if (mounted) {
        setState(() {
          _pdfController = controller;
          _totalPages = pagesCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar PDF: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    try {
      final fixedUrl = _fixFirebaseStorageUrl(widget.pdfUrl);
      final uri = Uri.parse(fixedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao abrir PDF: $e')),
        );
      }
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _pdfController?.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // A página atual será atualizada automaticamente pelo onPageChanged
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _pdfController?.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // A página atual será atualizada automaticamente pelo onPageChanged
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return SizedBox(
        height: screenHeight * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: appTheme.primary),
              const SizedBox(height: 16),
              Text(
                'Carregando PDF...',
                style: appTheme.bodyMedium.copyWith(
                  color: appTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return SizedBox(
        height: screenHeight * 0.6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: appTheme.error.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: appTheme.bodyMedium.copyWith(
                    color: appTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _initPdfController,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primary,
                    foregroundColor: appTheme.info,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_pdfController == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Header com título (se fornecido)
        if (widget.title != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: appTheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: appTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title!,
                    style: appTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: appTheme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Visualizador de PDF com altura fixa
        Container(
          height: screenHeight * 0.6,
          color: Colors.grey.shade200,
          child: PdfViewPinch(
            controller: _pdfController!,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            minScale: 1.5, // Zoom inicial maior para melhor legibilidade
            maxScale: 8.0, // Permite zoom de até 8x
            padding: 8,
          ),
        ),

        // Controles de navegação
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: appTheme.primaryBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão voltar página
              IconButton(
                onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Página anterior',
              ),

              // Indicador de página
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: appTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Página $_currentPage de $_totalPages',
                  style: appTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: appTheme.primaryText,
                  ),
                ),
              ),

              // Botão avançar página
              IconButton(
                onPressed:
                    _currentPage < _totalPages ? _goToNextPage : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Próxima página',
              ),
            ],
          ),
        ),

        // Botão de download (se habilitado)
        if (widget.showDownloadButton)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: _downloadPdf,
              icon: const Icon(Icons.download),
              label: const Text('Baixar PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: appTheme.primary,
                side: BorderSide(color: appTheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

        // Dica de zoom
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Toque duas vezes para aumentar | Pinch para ajustar zoom',
            style: appTheme.bodySmall.copyWith(
              color: appTheme.secondaryText,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

