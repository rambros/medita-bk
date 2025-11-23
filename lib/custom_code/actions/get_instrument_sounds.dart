// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
Future<List<AudioModelStruct>> getInstrumentSounds() async {
  final instrumentSounds = [
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Nenhum som selecionado',
      author: 'Rodrigo',
      fileLocation: '',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 0,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Bambu',
      author: 'Rodrigo',
      fileLocation: 'audios/bambu.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 12,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Chime',
      author: 'Rodrigo',
      fileLocation: 'audios/chime.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 13,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Gongo',
      author: 'Rodrigo',
      fileLocation: 'audios/gongo.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 5,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Kangse',
      author: 'Rodrigo',
      fileLocation: 'audios/kangse.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 16,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'KShanti',
      author: 'Rodrigo',
      fileLocation: 'audios/kshanti.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 4,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Ombu',
      author: 'Rodrigo',
      fileLocation: 'audios/ombu.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 13,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Piti',
      author: 'Rodrigo',
      fileLocation: 'sounds/gongo/piti.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 15,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Sino',
      author: 'Rodrigo',
      fileLocation: 'audios/sino.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 14,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Sino Tibetano',
      author: 'Rodrigo',
      fileLocation: 'audios/sino_tibetano.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 12,
    ),
    AudioModelStruct(
      id: DateTime.now().toIso8601String(),
      title: 'Upeksa',
      author: 'Rodrigo',
      fileLocation: 'audios/upeksa.mp3',
      fileType: FileType.asset,
      audioType: AudioType.instrument,
      duration: 13,
    ),
  ];
  return instrumentSounds;
}
