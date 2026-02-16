import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Utilitários para carregamento seguro de imagens de rede
///
/// Esta classe fornece métodos auxiliares para:
/// - Validar URLs de imagens
/// - Carregar imagens de rede com tratamento de erros
/// - Verificar conectividade de rede quando imagens falham
/// - Notificar usuários sobre problemas de conexão
/// - Exibir placeholders apropriados quando imagens falham
class ImageUtils {
  ImageUtils._(); // Private constructor to prevent instantiation

  /// Verifica se há conectividade de rede disponível
  ///
  /// Retorna `true` se há conexão WiFi, móvel ou ethernet.
  /// Retorna `false` se não há conexão ou apenas Bluetooth/VPN.
  static Future<bool> hasNetworkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      return connectivityResult.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false; // Assume sem conexão em caso de erro
    }
  }

  /// Valida se uma URL de imagem é válida e pode ser carregada
  ///
  /// Retorna `true` se:
  /// - A URL não é null ou vazia
  /// - A URL pode ser parseada
  /// - A URL tem um scheme (http/https)
  /// - A URL tem um host válido
  ///
  /// Exemplo:
  /// ```dart
  /// if (ImageUtils.isValidImageUrl(imageUrl)) {
  ///   // Safe to load image
  /// }
  /// ```
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    final parsedUrl = Uri.tryParse(url);
    return parsedUrl != null &&
           parsedUrl.hasScheme &&
           parsedUrl.host.isNotEmpty;
  }

  /// Constrói um widget de imagem de rede com tratamento de erros automático
  ///
  /// Este método:
  /// 1. Valida a URL antes de tentar carregar
  /// 2. Exibe um placeholder se a URL é inválida
  /// 3. Adiciona errorBuilder para capturar falhas de rede
  /// 4. Verifica conectividade e notifica usuário se for erro de rede
  /// 5. Retorna placeholder customizado ou padrão em caso de erro
  ///
  /// Parâmetros:
  /// - [url]: URL da imagem a ser carregada
  /// - [width]: Largura do widget
  /// - [height]: Altura do widget
  /// - [fit]: Como a imagem deve ser ajustada (padrão: BoxFit.cover)
  /// - [borderRadius]: Border radius opcional para ClipRRect
  /// - [placeholder]: Widget customizado para exibir durante carregamento
  /// - [errorWidget]: Widget customizado para exibir em caso de erro
  /// - [onError]: Callback chamado quando imagem falha ao carregar.
  ///   Recebe (isNetworkError: bool, errorMessage: String)
  ///
  /// Exemplo com notificação de erro de rede:
  /// ```dart
  /// ImageUtils.buildNetworkImage(
  ///   url: meditation.imageUrl,
  ///   width: 200,
  ///   height: 200,
  ///   onError: (isNetworkError, message) {
  ///     if (isNetworkError) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('Sem conexão: $message')),
  ///       );
  ///     }
  ///   },
  /// )
  /// ```
  static Widget buildNetworkImage({
    required String? url,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    void Function(bool isNetworkError, String errorMessage)? onError,
  }) {
    // Se URL inválida, mostra erro imediatamente
    if (!isValidImageUrl(url)) {
      if (onError != null) {
        onError(false, 'URL de imagem inválida ou vazia');
      }
      return errorWidget ?? _buildDefaultPlaceholder(width, height);
    }

    final imageWidget = Image.network(
      url!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: placeholder != null
          ? (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return placeholder;
            }
          : null,
      errorBuilder: (context, error, stackTrace) {
        // Verificar conectividade de forma assíncrona
        if (onError != null) {
          hasNetworkConnectivity().then((hasConnection) {
            final isNetworkError = !hasConnection;
            final errorMessage = isNetworkError
                ? 'Verifique sua conexão com a internet'
                : 'Erro ao carregar imagem: ${error.toString()}';
            onError(isNetworkError, errorMessage);
          });
        }
        return errorWidget ?? _buildDefaultPlaceholder(width, height);
      },
    );

    // Aplicar border radius se fornecido
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Constrói um widget de imagem de rede circular (para avatares, perfis, etc.)
  ///
  /// Exemplo com notificação de erro:
  /// ```dart
  /// ImageUtils.buildCircularNetworkImage(
  ///   url: user.profilePicture,
  ///   size: 80,
  ///   errorIcon: Icons.person,
  ///   onError: (isNetworkError, message) {
  ///     if (isNetworkError) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text(message)),
  ///       );
  ///     }
  ///   },
  /// )
  /// ```
  static Widget buildCircularNetworkImage({
    required String? url,
    required double size,
    IconData? errorIcon,
    Color? backgroundColor,
    void Function(bool isNetworkError, String errorMessage)? onError,
  }) {
    // Verificar URL inválida
    if (!isValidImageUrl(url)) {
      if (onError != null) {
        onError(false, 'URL de imagem inválida ou vazia');
      }
      return _buildCircularPlaceholder(
        size,
        errorIcon ?? Icons.person,
        backgroundColor,
      );
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.grey[300],
      ),
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Verificar conectividade de forma assíncrona
          if (onError != null) {
            hasNetworkConnectivity().then((hasConnection) {
              final isNetworkError = !hasConnection;
              final errorMessage = isNetworkError
                  ? 'Verifique sua conexão com a internet'
                  : 'Erro ao carregar imagem: ${error.toString()}';
              onError(isNetworkError, errorMessage);
            });
          }
          return _buildCircularPlaceholder(
            size,
            errorIcon ?? Icons.person,
            backgroundColor,
          );
        },
      ),
    );
  }

  /// Placeholder padrão para imagens que falharam ao carregar
  static Widget _buildDefaultPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[600],
        size: width * 0.4 > height * 0.4 ? height * 0.4 : width * 0.4,
      ),
    );
  }

  /// Placeholder circular para avatares/perfis
  static Widget _buildCircularPlaceholder(
    double size,
    IconData icon,
    Color? backgroundColor,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.grey[300],
      ),
      child: Icon(
        icon,
        color: Colors.grey[600],
        size: size * 0.5,
      ),
    );
  }

  /// Cria um placeholder com loading indicator
  static Widget buildLoadingPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: width * 0.2,
          height: width * 0.2,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        ),
      ),
    );
  }

  /// Cria um placeholder customizado com ícone específico
  static Widget buildCustomPlaceholder({
    required double width,
    required double height,
    required IconData icon,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[300],
      child: Icon(
        icon,
        color: iconColor ?? Colors.grey[600],
        size: width * 0.4 > height * 0.4 ? height * 0.4 : width * 0.4,
      ),
    );
  }
}
