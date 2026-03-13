/// Rotas do módulo Traffic Control
class TcRoutes {
  // Home - lista de alarmes
  static const String tcHome = 'TcHomePage';
  static const String tcHomePath = 'traffic-control';

  // Form - criar/editar alarme
  static const String tcAlarmFormNew = 'TcAlarmFormPageNew';
  static const String tcAlarmFormNewPath = 'traffic-control/new';

  static const String tcAlarmFormEdit = 'TcAlarmFormPageEdit';
  static const String tcAlarmFormEditPath = 'traffic-control/edit/:id';

  // Music Picker - seleção de música
  static const String tcMusicPicker = 'TcMusicPickerPage';
  static const String tcMusicPickerPath = 'traffic-control/music-picker';
}
