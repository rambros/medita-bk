import 'package:collection/collection.dart';

enum AudioType {
  music,
  ambient,
  instrument,
  silence,
  meditation,
  device_music,
  device_music_invalid,
}

enum FileType {
  asset,
  url,
  file,
  silence,
}

enum D21Status {
  open,
  closed,
  completed,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) => firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (AudioType):
      return AudioType.values.deserialize(value) as T?;
    case (FileType):
      return FileType.values.deserialize(value) as T?;
    case (D21Status):
      return D21Status.values.deserialize(value) as T?;
    default:
      return null;
  }
}
