// Automatic FlutterFlow imports
import 'package:medita_bk/core/structs/index.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:medita_bk/core/controllers/index.dart';
import 'audio_player_controls.dart';
import 'package:flutter/services.dart';

class FFPlaylistPlayerWidget extends StatefulWidget {
  const FFPlaylistPlayerWidget({
    super.key,
    this.width,
    this.height,
    required this.playlistTitle,
    required this.playlistArt,
    this.colorButton,
    required this.listAudios,
  });

  final double? width;
  final double? height;
  final String playlistTitle;
  final String playlistArt;
  final Color? colorButton;
  final List<AudioModelStruct> listAudios;

  @override
  FFPlaylistPlayerWidgetState createState() => FFPlaylistPlayerWidgetState();
}

class FFPlaylistPlayerWidgetState extends State<FFPlaylistPlayerWidget> {
  AudioPlayerController playlistPlayerController = globalAudioPlayerController;

  @override
  void initState() {
    super.initState();
    final playlistModel = PlaylistModel(
      id: widget.playlistTitle,
      title: widget.playlistTitle,
      urlImage: widget.playlistArt,
      listAudios: widget.listAudios,
    );
    playlistPlayerController.initPlaylistPlayer(playlistModel);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  @override
  void dispose() {
    playlistPlayerController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CurrentSongTitle(),
            SizedBox(
              height: 18,
            ),
            AudioProgressBar(),
            PlaylistAudioControlButtons(),
          ],
        ),
      ),
    );
  }
}

class PlaylistAudioControlButtons extends StatelessWidget {
  const PlaylistAudioControlButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          //ShuffleButton(),
        ],
      ),
    );
  }
}
