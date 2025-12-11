import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:medita_bk/core/controllers/audio_player_controller.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: playerController.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: playerController.seek,
          baseBarColor: Colors.white10,
          bufferedBarColor: Colors.white30,
          progressBarColor: Colors.white,
          thumbColor: Colors.white,
          timeLabelTextStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<ButtonState>(
      valueListenable: playerController.playButtonNotifier,
      // ignore: missing_return
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 56.0,
              height: 64.0,
              //color: Colors.black,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 68.0,
              color: Colors.white,
              onPressed: playerController.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 64.0,
              color: Colors.white,
              onPressed: playerController.pause,
            );
        }
      },
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<RepeatState>(
      valueListenable: playerController.repeatButtonNotifier,
      builder: (context, value, child) {
        late Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: playerController.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 56.0,
          color: Colors.white,
          onPressed: (isFirst) ? null : playerController.previous,
        );
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 56.0,
          color: Colors.white,
          onPressed: (isLast) ? null : playerController.next,
        );
      },
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({super.key});
  @override
  Widget build(BuildContext context) {
    final playerController = globalAudioPlayerController;
    final listAudios = playerController.listAudios;
    return ValueListenableBuilder<int>(
      valueListenable: playerController.currentIndexTitleNotifier,
      builder: (_, index, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            listAudios.isNotEmpty && index < listAudios.length ? listAudios[index].title : 'Carregando...',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      },
    );
  }
}
