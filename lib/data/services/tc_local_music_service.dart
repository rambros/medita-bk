import 'package:just_audio/just_audio.dart';
import 'package:medita_bk/domain/models/traffic_control/tc_music_entity.dart';

/// Service para listar músicas locais dos assets (iOS apenas)
///
/// No iOS, o pacote alarm não consegue tocar arquivos MP3/M4A baixados
/// do sistema de arquivos em alarmes background. Por isso, usamos assets locais.
class TcLocalMusicService {
  /// Retorna lista hard-coded das 7 músicas em assets/tc_musicas/
  ///
  /// IMPORTANTE: Esta lista deve ser mantida manualmente.
  /// Se adicionar/remover arquivos em assets/tc_musicas/, atualizar aqui.
  static List<TcMusicEntity> getLocalMusics() {
    return [
      TcMusicEntity(
        id: 'local_jam1',
        title: 'Despertar Sereno',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam1.m4a',
        durationSec: 60, // Será atualizado dinamicamente
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam2',
        title: 'Brisa Interior',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam2.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam3',
        title: 'Caminho de Luz',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam3.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam4',
        title: 'Harmonia Profunda',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam4.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam5',
        title: 'Leveza e Contentamento',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam5.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam6',
        title: 'Florescer da Alma',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam6.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
      TcMusicEntity(
        id: 'local_jam7',
        title: 'Oceano de Calma',
        artist: 'Brahma Kumaris',
        audioUrl: 'assets/tc_musicas/jam7.m4a',
        durationSec: 60,
        category: 'Meditação',
        isActive: true,
      ),
    ];
  }

  /// Obtém duração real de um asset de áudio usando just_audio
  ///
  /// Usar este método durante inicialização para atualizar durationSec
  static Future<int?> getAssetDuration(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(assetPath);
      final duration = player.duration;
      await player.dispose();
      return duration?.inSeconds;
    } catch (e) {
      print('TcLocalMusic: Erro ao obter duração de $assetPath: $e');
      return null;
    }
  }

  /// Carrega músicas com durações reais (opcional - para melhor UX)
  ///
  /// Usa getAssetDuration() para cada música e atualiza durationSec
  static Future<List<TcMusicEntity>> getLocalMusicsWithDurations() async {
    final musics = getLocalMusics();
    final List<TcMusicEntity> musicsWithDurations = [];

    for (final music in musics) {
      final duration = await getAssetDuration(music.audioUrl);
      if (duration != null) {
        musicsWithDurations.add(music.copyWith(durationSec: duration));
      } else {
        musicsWithDurations.add(music); // Mantém 60s como padrão
      }
    }

    return musicsWithDurations;
  }
}
