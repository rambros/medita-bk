import 'package:flutter/material.dart';
import '/core/structs/index.dart';
import '/ui/core/flutter_flow/request_manager.dart';
import '/data/models/firebase/firebase_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';
import '/core/utils/logger.dart';

class AppStateStore extends ChangeNotifier {
  static AppStateStore _instance = AppStateStore._internal();

  factory AppStateStore() {
    return _instance;
  }

  AppStateStore._internal();

  static void reset() {
    _instance = AppStateStore._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _darkTheme = prefs.getBool('ff_darkTheme') ?? _darkTheme;
    });
    _safeInit(() {
      _receiveNotifications = prefs.getBool('ff_receiveNotifications') ?? _receiveNotifications;
    });
    _safeInit(() {
      _receiveEmails = prefs.getBool('ff_receiveEmails') ?? _receiveEmails;
    });
    _safeInit(() {
      _alarms = prefs
              .getStringList('ff_alarms')
              ?.map((x) {
                try {
                  return AlarmTimeStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  logDebug("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _alarms;
    });
    _safeInit(() {
      _dataMensagemHoje = prefs.getString('ff_dataMensagemHoje') ?? _dataMensagemHoje;
    });
    _safeInit(() {
      _indexMensagemHoje = prefs.getInt('ff_indexMensagemHoje') ?? _indexMensagemHoje;
    });
    _safeInit(() {
      _meditationLogList = prefs
              .getStringList('ff_meditationLogList')
              ?.map((x) {
                try {
                  return MeditationLogStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  logDebug("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _meditationLogList;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    prefs.setBool('ff_darkTheme', value);
  }

  bool _habilitaDesafio21 = false;
  bool get habilitaDesafio21 => _habilitaDesafio21;
  set habilitaDesafio21(bool value) {
    _habilitaDesafio21 = value;
  }

  DateTime? _diaInicioDesafio21;
  DateTime? get diaInicioDesafio21 => _diaInicioDesafio21;
  set diaInicioDesafio21(DateTime? value) {
    _diaInicioDesafio21 = value;
  }

  bool _receiveNotifications = true;
  bool get receiveNotifications => _receiveNotifications;
  set receiveNotifications(bool value) {
    _receiveNotifications = value;
    prefs.setBool('ff_receiveNotifications', value);
  }

  bool _receiveEmails = true;
  bool get receiveEmails => _receiveEmails;
  set receiveEmails(bool value) {
    _receiveEmails = value;
    prefs.setBool('ff_receiveEmails', value);
  }

  bool _desafioStarted = false;
  bool get desafioStarted => _desafioStarted;
  set desafioStarted(bool value) {
    _desafioStarted = value;
  }

  List<AlarmTimeStruct> _alarms = [];
  List<AlarmTimeStruct> get alarms => _alarms;
  set alarms(List<AlarmTimeStruct> value) {
    _alarms = value;
    prefs.setStringList('ff_alarms', value.map((x) => x.serialize()).toList());
  }

  void addToAlarms(AlarmTimeStruct value) {
    alarms.add(value);
    prefs.setStringList('ff_alarms', _alarms.map((x) => x.serialize()).toList());
  }

  void removeFromAlarms(AlarmTimeStruct value) {
    alarms.remove(value);
    prefs.setStringList('ff_alarms', _alarms.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromAlarms(int index) {
    alarms.removeAt(index);
    prefs.setStringList('ff_alarms', _alarms.map((x) => x.serialize()).toList());
  }

  void updateAlarmsAtIndex(
    int index,
    AlarmTimeStruct Function(AlarmTimeStruct) updateFn,
  ) {
    alarms[index] = updateFn(_alarms[index]);
    prefs.setStringList('ff_alarms', _alarms.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInAlarms(int index, AlarmTimeStruct value) {
    alarms.insert(index, value);
    prefs.setStringList('ff_alarms', _alarms.map((x) => x.serialize()).toList());
  }

  String _dataMensagemHoje = '2000-10-10';
  String get dataMensagemHoje => _dataMensagemHoje;
  set dataMensagemHoje(String value) {
    _dataMensagemHoje = value;
    prefs.setString('ff_dataMensagemHoje', value);
  }

  int _indexMensagemHoje = 100;
  int get indexMensagemHoje => _indexMensagemHoje;
  set indexMensagemHoje(int value) {
    _indexMensagemHoje = value;
    prefs.setInt('ff_indexMensagemHoje', value);
  }

  List<MeditationLogStruct> _meditationLogList = [];
  List<MeditationLogStruct> get meditationLogList => _meditationLogList;
  set meditationLogList(List<MeditationLogStruct> value) {
    _meditationLogList = value;
    prefs.setStringList('ff_meditationLogList', value.map((x) => x.serialize()).toList());
  }

  void addToMeditationLogList(MeditationLogStruct value) {
    meditationLogList.add(value);
    prefs.setStringList('ff_meditationLogList', _meditationLogList.map((x) => x.serialize()).toList());
  }

  void removeFromMeditationLogList(MeditationLogStruct value) {
    meditationLogList.remove(value);
    prefs.setStringList('ff_meditationLogList', _meditationLogList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMeditationLogList(int index) {
    meditationLogList.removeAt(index);
    prefs.setStringList('ff_meditationLogList', _meditationLogList.map((x) => x.serialize()).toList());
  }

  void updateMeditationLogListAtIndex(
    int index,
    MeditationLogStruct Function(MeditationLogStruct) updateFn,
  ) {
    meditationLogList[index] = updateFn(_meditationLogList[index]);
    prefs.setStringList('ff_meditationLogList', _meditationLogList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMeditationLogList(int index, MeditationLogStruct value) {
    meditationLogList.insert(index, value);
    prefs.setStringList('ff_meditationLogList', _meditationLogList.map((x) => x.serialize()).toList());
  }

  List<AudioModelStruct> _listAudiosSelected = [];
  List<AudioModelStruct> get listAudiosSelected => _listAudiosSelected;
  set listAudiosSelected(List<AudioModelStruct> value) {
    _listAudiosSelected = value;
  }

  void addToListAudiosSelected(AudioModelStruct value) {
    listAudiosSelected.add(value);
  }

  void removeFromListAudiosSelected(AudioModelStruct value) {
    listAudiosSelected.remove(value);
  }

  void removeAtIndexFromListAudiosSelected(int index) {
    listAudiosSelected.removeAt(index);
  }

  void updateListAudiosSelectedAtIndex(
    int index,
    AudioModelStruct Function(AudioModelStruct) updateFn,
  ) {
    listAudiosSelected[index] = updateFn(_listAudiosSelected[index]);
  }

  void insertAtIndexInListAudiosSelected(int index, AudioModelStruct value) {
    listAudiosSelected.insert(index, value);
  }

  AudioModelStruct _tempAudioModel =
      AudioModelStruct.fromSerializableMap(jsonDecode('{\"fileType\":\"file\",\"audioType\":\"device_music\"}'));
  AudioModelStruct get tempAudioModel => _tempAudioModel;
  set tempAudioModel(AudioModelStruct value) {
    _tempAudioModel = value;
  }

  void updateTempAudioModelStruct(Function(AudioModelStruct) updateFn) {
    updateFn(_tempAudioModel);
  }

  PlaylistModelStruct _tempPlaylist = PlaylistModelStruct();
  PlaylistModelStruct get tempPlaylist => _tempPlaylist;
  set tempPlaylist(PlaylistModelStruct value) {
    _tempPlaylist = value;
  }

  void updateTempPlaylistStruct(Function(PlaylistModelStruct) updateFn) {
    updateFn(_tempPlaylist);
  }

  List<AudioModelStruct> _listAudiosReadyToPlay = [];
  List<AudioModelStruct> get listAudiosReadyToPlay => _listAudiosReadyToPlay;
  set listAudiosReadyToPlay(List<AudioModelStruct> value) {
    _listAudiosReadyToPlay = value;
  }

  void addToListAudiosReadyToPlay(AudioModelStruct value) {
    listAudiosReadyToPlay.add(value);
  }

  void removeFromListAudiosReadyToPlay(AudioModelStruct value) {
    listAudiosReadyToPlay.remove(value);
  }

  void removeAtIndexFromListAudiosReadyToPlay(int index) {
    listAudiosReadyToPlay.removeAt(index);
  }

  void updateListAudiosReadyToPlayAtIndex(
    int index,
    AudioModelStruct Function(AudioModelStruct) updateFn,
  ) {
    listAudiosReadyToPlay[index] = updateFn(_listAudiosReadyToPlay[index]);
  }

  void insertAtIndexInListAudiosReadyToPlay(int index, AudioModelStruct value) {
    listAudiosReadyToPlay.insert(index, value);
  }

  D21ModelStruct _desafio21 = D21ModelStruct();
  D21ModelStruct get desafio21 => _desafio21;
  set desafio21(D21ModelStruct value) {
    _desafio21 = value;
    notifyListeners();
  }

  void updateDesafio21Struct(Function(D21ModelStruct) updateFn) {
    updateFn(_desafio21);
  }

  List<D21EtapaModelStruct> _listaEtapasMandalas = [];
  List<D21EtapaModelStruct> get listaEtapasMandalas => _listaEtapasMandalas;
  set listaEtapasMandalas(List<D21EtapaModelStruct> value) {
    _listaEtapasMandalas = value;
    notifyListeners();
  }

  void addToListaEtapasMandalas(D21EtapaModelStruct value) {
    listaEtapasMandalas.add(value);
  }

  void removeFromListaEtapasMandalas(D21EtapaModelStruct value) {
    listaEtapasMandalas.remove(value);
  }

  void removeAtIndexFromListaEtapasMandalas(int index) {
    listaEtapasMandalas.removeAt(index);
  }

  void updateListaEtapasMandalasAtIndex(
    int index,
    D21EtapaModelStruct Function(D21EtapaModelStruct) updateFn,
  ) {
    listaEtapasMandalas[index] = updateFn(_listaEtapasMandalas[index]);
  }

  void insertAtIndexInListaEtapasMandalas(int index, D21EtapaModelStruct value) {
    listaEtapasMandalas.insert(index, value);
  }

  String _downloadStatus = '';
  String get downloadStatus => _downloadStatus;
  set downloadStatus(String value) {
    _downloadStatus = value;
  }

  List<String> _listaEbooksDesafio21 = [
    'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fpremios%2FA%20paz%20comec%CC%A7a%20com%20voce%20-%2001.jpg?alt=media&token=0bbde78e-742c-47c9-8288-15ec8c5f3c97',
    'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fpremios%2Fresolucao_conflitos_capa%20-%2001.jpg?alt=media&token=8b89118a-09fd-40d8-b968-ac7321421ace',
    'https://firebasestorage.googleapis.com/v0/b/meditabk2020.appspot.com/o/desafio%2Fpremios%2FCaminhos%20-%20Capa%202018%20-%2001.jpg?alt=media&token=025a8907-c57e-4146-a2aa-8e00096062f4'
  ];
  List<String> get listaEbooksDesafio21 => _listaEbooksDesafio21;
  set listaEbooksDesafio21(List<String> value) {
    _listaEbooksDesafio21 = value;
  }

  void addToListaEbooksDesafio21(String value) {
    listaEbooksDesafio21.add(value);
  }

  void removeFromListaEbooksDesafio21(String value) {
    listaEbooksDesafio21.remove(value);
  }

  void removeAtIndexFromListaEbooksDesafio21(int index) {
    listaEbooksDesafio21.removeAt(index);
  }

  void updateListaEbooksDesafio21AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    listaEbooksDesafio21[index] = updateFn(_listaEbooksDesafio21[index]);
  }

  void insertAtIndexInListaEbooksDesafio21(int index, String value) {
    listaEbooksDesafio21.insert(index, value);
  }

  bool _hasInternetAccess = false;
  bool get hasInternetAccess => _hasInternetAccess;
  set hasInternetAccess(bool value) {
    _hasInternetAccess = value;
  }

  final _listaAutoresManager = StreamRequestManager<List<UserModel>>();
  Stream<List<UserModel>> listaAutores({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<UserModel>> Function() requestFn,
  }) =>
      _listaAutoresManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListaAutoresCache() => _listaAutoresManager.clear();
  void clearListaAutoresCacheKey(String? uniqueKey) => _listaAutoresManager.clearRequest(uniqueKey);

  final _listMeditationsManager = StreamRequestManager<List<MeditationModel>>();
  Stream<List<MeditationModel>> listMeditations({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<MeditationModel>> Function() requestFn,
  }) =>
      _listMeditationsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListMeditationsCache() => _listMeditationsManager.clear();
  void clearListMeditationsCacheKey(String? uniqueKey) => _listMeditationsManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}
