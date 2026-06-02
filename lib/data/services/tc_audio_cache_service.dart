// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service para gerenciar cache de áudios do Traffic Control
class TcAudioCacheService {
  static const String _cacheKey = 'tc_audio_cache';
  static const int _maxCacheObjects = 50;
  static const Duration _stalePeriod = Duration(days: 30);
  static const String _alarmAudioDir = 'tc_alarm_audios'; // Diretório para áudios de alarme

  late final CacheManager _cacheManager;

  TcAudioCacheService() {
    _cacheManager = CacheManager(
      Config(
        _cacheKey,
        stalePeriod: _stalePeriod,
        maxNrOfCacheObjects: _maxCacheObjects,
      ),
    );
  }

  /// Garante que o áudio está disponível e retorna o path
  ///
  /// - Se for asset (começa com 'assets/'), retorna o path sem cachear
  /// - Se for URL, faz download e retorna path local
  ///
  /// IMPORTANTE: Para iOS, copia arquivos baixados para o diretório de documentos
  /// para garantir que o alarme consiga acessá-los em background.
  Future<String> ensureCached(String url) async {
    // Se é asset, não precisa cachear
    if (url.startsWith('assets/')) {
      print('TcAudioCache: Asset detectado, não precisa cachear: $url');
      return url;
    }

    // Se é URL, faz cache normal
    try {
      // 1. Primeiro, garante que está no cache manager
      FileInfo? fileInfo = await _cacheManager.getFileFromCache(url);

      if (fileInfo == null || !fileInfo.file.existsSync()) {
        print('TcAudioCache: Baixando arquivo: $url');
        final downloadedFile = await _cacheManager.downloadFile(url);
        fileInfo = FileInfo(
          downloadedFile.file,
          FileSource.Online,
          downloadedFile.validTill,
          url,
        );
        print('TcAudioCache: Download completo');
      } else {
        print('TcAudioCache: Arquivo já em cache');
      }

      // 2. Para iOS/alarmes, copia para diretório de documentos
      final alarmAudioPath = await _copyToDocumentsDir(fileInfo.file, url);
      print('TcAudioCache: Arquivo copiado para: $alarmAudioPath');

      return alarmAudioPath;
    } catch (e) {
      print('TcAudioCache: Erro ao garantir cache: $e');
      rethrow;
    }
  }

  /// Copia arquivo do cache para o diretório de documentos
  ///
  /// Isso é necessário no iOS porque alarmes em background podem não
  /// ter acesso ao diretório de cache temporário do app.
  Future<String> _copyToDocumentsDir(File cachedFile, String url) async {
    try {
      // Obtém diretório de documentos
      final documentsDir = await getApplicationDocumentsDirectory();
      final alarmDir = Directory(path.join(documentsDir.path, _alarmAudioDir));

      // Cria diretório se não existir
      if (!await alarmDir.exists()) {
        await alarmDir.create(recursive: true);
        print('TcAudioCache: Diretório de alarmes criado: ${alarmDir.path}');
      }

      // Gera nome do arquivo baseado na URL (hash para evitar caracteres inválidos)
      final fileName = url.hashCode.abs().toString() + path.extension(cachedFile.path);
      final targetPath = path.join(alarmDir.path, fileName);
      final targetFile = File(targetPath);

      // Se já existe e é válido, retorna
      if (await targetFile.exists()) {
        print('TcAudioCache: Arquivo já existe em documentos: $targetPath');
        return targetPath;
      }

      // Copia arquivo
      await cachedFile.copy(targetPath);
      print('TcAudioCache: Arquivo copiado de ${cachedFile.path} para $targetPath');

      return targetPath;
    } catch (e) {
      print('TcAudioCache: Erro ao copiar para documentos: $e');
      // Se falhar, retorna o path original do cache como fallback
      return cachedFile.path;
    }
  }

  /// Verifica se um áudio está em cache
  Future<bool> isCached(String url) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      return fileInfo != null && fileInfo.file.existsSync();
    } catch (e) {
      print('TcAudioCache: Erro ao verificar cache: $e');
      return false;
    }
  }

  /// Obtém informações do arquivo em cache (se existir)
  Future<File?> getCachedFile(String url) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);

      if (fileInfo != null && fileInfo.file.existsSync()) {
        return fileInfo.file;
      }

      return null;
    } catch (e) {
      print('TcAudioCache: Erro ao obter arquivo: $e');
      return null;
    }
  }

  /// Remove um arquivo específico do cache
  Future<void> removeFromCache(String url) async {
    try {
      await _cacheManager.removeFile(url);
      print('TcAudioCache: Arquivo removido do cache: $url');
    } catch (e) {
      print('TcAudioCache: Erro ao remover arquivo: $e');
    }
  }

  /// Limpa todo o cache de áudios
  Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      print('TcAudioCache: Cache limpo com sucesso');
    } catch (e) {
      print('TcAudioCache: Erro ao limpar cache: $e');
    }
  }

  /// Obtém o tamanho total do cache em bytes
  Future<int> getCacheSize() async {
    try {
      // Nota: flutter_cache_manager não expõe diretamente o tamanho
      // Como workaround, retornamos uma estimativa ou 0
      // Para implementação completa, seria necessário acessar o FileSystem
      return 0; // TODO: Implementar cálculo real de tamanho
    } catch (e) {
      print('TcAudioCache: Erro ao calcular tamanho do cache: $e');
      return 0;
    }
  }

  /// Obtém o tamanho do cache formatado (MB)
  Future<String> getFormattedCacheSize() async {
    final sizeBytes = await getCacheSize();
    final sizeMB = sizeBytes / (1024 * 1024);

    if (sizeMB < 1) {
      final sizeKB = sizeBytes / 1024;
      return '${sizeKB.toStringAsFixed(1)} KB';
    }

    return '${sizeMB.toStringAsFixed(1)} MB';
  }

  /// Pré-carrega múltiplos áudios em cache
  Future<void> preloadMultiple(List<String> urls) async {
    print('TcAudioCache: Pré-carregando ${urls.length} áudios...');

    for (final url in urls) {
      try {
        await ensureCached(url);
      } catch (e) {
        print('TcAudioCache: Erro ao pré-carregar $url: $e');
        // Continua com os próximos mesmo se um falhar
      }
    }

    print('TcAudioCache: Pré-carregamento concluído');
  }
}
