import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/schema/enums/enums.dart';

/// Global audio handler instance for background audio playback
late AudioHandler globalAudioHandler;

/// Audio service for managing background audio playback with caching support
class MeditaBKAudioService {
  /// Initialize the audio service
  ///
  /// This must be called before using any audio functionality.
  /// Creates a global [AudioHandler] instance for background playback.
  static Future<void> initialize() async {
    globalAudioHandler = await AudioService.init(
      builder: () => _AudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio Service Demo',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }
}

/// Custom audio handler for managing playback, queue, and caching
class _AudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(
    children: [],
    useLazyPreparation: false,
  );

  _AudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      debugPrint('Error loading empty playlist: $e');
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled) ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index];
      duration = duration ?? const Duration(milliseconds: 0);
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final sources = await Future.wait(mediaItems.map(_createAudioSource));
    await _playlist.addAll(sources);

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final source = await _createAudioSource(mediaItem);
    await _playlist.add(source);

    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  Future<IndexedAudioSource> _createAudioSource(MediaItem mediaItem) async {
    final extras = mediaItem.extras ?? {};
    final url = extras['url'] as String?;

    if (extras['fileType'] == FileType.asset.toString()) {
      if (url == null) {
        throw ArgumentError('Asset audio requires url reference');
      }
      final nomeArquivo = path.basename(url);
      return AudioSource.uri(
        Uri.parse('asset:///assets/audios/$nomeArquivo'),
        tag: mediaItem,
      );
    }

    if (extras['audioType'] == AudioType.silence.toString()) {
      return ClippingAudioSource(
        start: const Duration(seconds: 0),
        end: Duration(seconds: mediaItem.duration!.inSeconds),
        tag: mediaItem,
        child: AudioSource.uri(
          Uri.parse('asset:///assets/audios/silence60.m4a'),
          tag: mediaItem,
        ),
      );
    }

    if (extras['audioType'] == AudioType.device_music.toString()) {
      if (url == null) {
        throw ArgumentError('Device music requires local file path');
      }
      return ClippingAudioSource(
        start: const Duration(seconds: 0),
        end: Duration(seconds: mediaItem.duration!.inSeconds),
        tag: mediaItem,
        child: AudioSource.uri(
          Uri.file(url),
          tag: mediaItem,
        ),
      );
    }

    // Check if audio is in cache
    if (url != null) {
      final cached = await _resolveCachedPath(url);
      if (cached != null && File(cached).existsSync()) {
        return AudioSource.uri(Uri.file(cached), tag: mediaItem);
      }
    }

    if (url == null) {
      throw ArgumentError('MediaItem url is required');
    }

    return AudioSource.uri(Uri.parse(url), tag: mediaItem);
  }

  // Cache management methods
  Future<String> _cacheFilePath(String url) async {
    final directory = await _cacheDirectory();
    final fileName = _cacheFileName(url);
    return path.join(directory.path, fileName);
  }

  Future<Directory> _cacheDirectory() async {
    final basePath = await _cacheBasePath();
    final cacheDir = Directory(basePath);
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    return cacheDir;
  }

  Future<String> _cacheBasePath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return path.join(docsDir.path, 'audio_cache');
  }

  String _cacheFileName(String url) {
    final uri = Uri.parse(url);
    final decodedBase = Uri.decodeComponent(path.basename(uri.path));
    final baseName = decodedBase.isNotEmpty ? decodedBase : uri.path.replaceAll('/', '_');
    final host = uri.host.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final rawName = [
      if (host.isNotEmpty) host,
      if (baseName.isNotEmpty) baseName,
    ].join('_');
    final sanitized = _sanitizeFileName(
      rawName.isNotEmpty ? rawName : uri.toString(),
    );
    return sanitized;
  }

  Future<String?> _resolveCachedPath(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final candidateSuffix = _cachePreferenceKey(url);
    final manualEntry = prefs.getString(url);
    if (manualEntry != null) {
      if (!prefs.containsKey(candidateSuffix)) {
        prefs.setString(candidateSuffix, manualEntry);
      }
      return manualEntry;
    }
    final suffixEntry = prefs.getString(candidateSuffix);
    if (suffixEntry != null) {
      return suffixEntry;
    }
    final extensionEntry = await _player.getCachedPath(url: url);
    return extensionEntry;
  }

  Future<void> _registerCachePath(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final targetPath = await _cacheFilePath(url);
    prefs.setString(url, targetPath);
    prefs.setString(_cachePreferenceKey(url), targetPath);
  }

  Future<bool> _cachedFileExists(String? cachedPath) async {
    if (cachedPath == null) {
      return false;
    }
    return File(cachedPath).existsSync();
  }

  Future<void> _purgeCacheEntry(String url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(url);
    prefs.remove(_cachePreferenceKey(url));
  }

  Future<void> _clearCacheMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final basePath = await _cacheBasePath();
    final keysToRemove = <String>[];
    for (final key in prefs.getKeys()) {
      final value = prefs.getString(key);
      if (value != null && value.startsWith(basePath)) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      prefs.remove(key);
    }
  }

  String _cachePreferenceKey(String url) {
    final uri = Uri.parse(url);
    final parts = uri.path.split('/');
    if (parts.isNotEmpty) {
      final buffer = StringBuffer();
      for (final part in parts) {
        buffer.write(part);
      }
      final value = buffer.toString();
      if (value.isNotEmpty) {
        return value;
      }
    }
    return uri.host;
  }

  String _sanitizeFileName(String value) {
    final sanitized = value.replaceAll('%2F', '_').replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').replaceAll('%', '_');
    return sanitized.replaceAll(RegExp('_+'), '_');
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _playlist.removeAt(index);
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices![index];
    }
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      await _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'cacheAudio':
        final url = extras?['url'] as String?;
        if (url == null || url.isEmpty) {
          throw ArgumentError('cacheAudio requires a non-empty url');
        }
        final cachedPath = await _resolveCachedPath(url);
        if (await _cachedFileExists(cachedPath)) {
          return true;
        }
        await _player.existedInLocal(url: url);
        final targetPath = await _cacheFilePath(url);
        await _player.cacheFile(url: url, path: targetPath);
        await _registerCachePath(url);
        return true;
      case 'isCached':
        final url = extras?['url'] as String?;
        if (url == null || url.isEmpty) {
          return false;
        }
        final cachedPath = await _resolveCachedPath(url);
        final exists = await _cachedFileExists(cachedPath);
        if (!exists) {
          await _purgeCacheEntry(url);
        }
        return exists;
      case 'clearCache':
        try {
          await _player.clearCache();
        } catch (e) {
          debugPrint('AudioService clearCache fallback: $e');
          final basePath = await _cacheBasePath();
          final cacheDir = Directory(basePath);
          if (cacheDir.existsSync()) {
            cacheDir.deleteSync(recursive: true);
          }
        }
        await _clearCacheMetadata();
        await _cacheDirectory();
        return true;
      case 'dispose':
        await _player.dispose();
        await super.stop();
        return true;
      default:
        return super.customAction(name, extras);
    }
  }

  @override
  Future<void> stop() async {
    await _player.seek(Duration.zero, index: 0);
    await _playlist.clear();
    await _player.stop();

    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
    await super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }
}
