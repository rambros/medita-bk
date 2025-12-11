// ignore_for_file: unnecessary_getters_setters
import 'package:medita_bk/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_bk/core/structs/util/firestore_util.dart';

import 'index.dart';
import 'package:medita_bk/ui/core/flutter_flow/flutter_flow_util.dart';

class EventModelStruct extends FFFirebaseStruct {
  EventModelStruct({
    int? id,
    int? index,
    bool? archived,
    bool? featured,
    bool? hasWebcast,
    String? webcastUrl,
    bool? onlineOnly,
    int? eventTypeId,
    int? orgId,
    String? name,
    String? shortDescription,
    String? description,
    String? descriptionText,
    int? eventDateId,
    bool? hasImage1,
    bool? requiresRegistration,
    int? registrationCount,
    int? maxParticipants,
    String? startTimestamp,
    String? startIso,
    String? endTimestamp,
    String? endIso,
    VenueStruct? venue,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _index = index,
        _archived = archived,
        _featured = featured,
        _hasWebcast = hasWebcast,
        _webcastUrl = webcastUrl,
        _onlineOnly = onlineOnly,
        _eventTypeId = eventTypeId,
        _orgId = orgId,
        _name = name,
        _shortDescription = shortDescription,
        _description = description,
        _descriptionText = descriptionText,
        _eventDateId = eventDateId,
        _hasImage1 = hasImage1,
        _requiresRegistration = requiresRegistration,
        _registrationCount = registrationCount,
        _maxParticipants = maxParticipants,
        _startTimestamp = startTimestamp,
        _startIso = startIso,
        _endTimestamp = endTimestamp,
        _endIso = endIso,
        _venue = venue,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "index" field.
  int? _index;
  int get index => _index ?? 0;
  set index(int? val) => _index = val;

  void incrementIndex(int amount) => index = index + amount;

  bool hasIndex() => _index != null;

  // "archived" field.
  bool? _archived;
  bool get archived => _archived ?? false;
  set archived(bool? val) => _archived = val;

  bool hasArchived() => _archived != null;

  // "featured" field.
  bool? _featured;
  bool get featured => _featured ?? false;
  set featured(bool? val) => _featured = val;

  bool hasFeatured() => _featured != null;

  // "hasWebcast" field.
  bool? _hasWebcast;
  bool get hasWebcast => _hasWebcast ?? false;
  set hasWebcast(bool? val) => _hasWebcast = val;

  bool hasHasWebcast() => _hasWebcast != null;

  // "webcastUrl" field.
  String? _webcastUrl;
  String get webcastUrl => _webcastUrl ?? '';
  set webcastUrl(String? val) => _webcastUrl = val;

  bool hasWebcastUrl() => _webcastUrl != null;

  // "onlineOnly" field.
  bool? _onlineOnly;
  bool get onlineOnly => _onlineOnly ?? false;
  set onlineOnly(bool? val) => _onlineOnly = val;

  bool hasOnlineOnly() => _onlineOnly != null;

  // "eventTypeId" field.
  int? _eventTypeId;
  int get eventTypeId => _eventTypeId ?? 0;
  set eventTypeId(int? val) => _eventTypeId = val;

  void incrementEventTypeId(int amount) => eventTypeId = eventTypeId + amount;

  bool hasEventTypeId() => _eventTypeId != null;

  // "orgId" field.
  int? _orgId;
  int get orgId => _orgId ?? 0;
  set orgId(int? val) => _orgId = val;

  void incrementOrgId(int amount) => orgId = orgId + amount;

  bool hasOrgId() => _orgId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "shortDescription" field.
  String? _shortDescription;
  String get shortDescription => _shortDescription ?? '';
  set shortDescription(String? val) => _shortDescription = val;

  bool hasShortDescription() => _shortDescription != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "descriptionText" field.
  String? _descriptionText;
  String get descriptionText => _descriptionText ?? '';
  set descriptionText(String? val) => _descriptionText = val;

  bool hasDescriptionText() => _descriptionText != null;

  // "eventDateId" field.
  int? _eventDateId;
  int get eventDateId => _eventDateId ?? 0;
  set eventDateId(int? val) => _eventDateId = val;

  void incrementEventDateId(int amount) => eventDateId = eventDateId + amount;

  bool hasEventDateId() => _eventDateId != null;

  // "hasImage1" field.
  bool? _hasImage1;
  bool get hasImage1 => _hasImage1 ?? false;
  set hasImage1(bool? val) => _hasImage1 = val;

  bool hasHasImage1() => _hasImage1 != null;

  // "requiresRegistration" field.
  bool? _requiresRegistration;
  bool get requiresRegistration => _requiresRegistration ?? false;
  set requiresRegistration(bool? val) => _requiresRegistration = val;

  bool hasRequiresRegistration() => _requiresRegistration != null;

  // "registrationCount" field.
  int? _registrationCount;
  int get registrationCount => _registrationCount ?? 0;
  set registrationCount(int? val) => _registrationCount = val;

  void incrementRegistrationCount(int amount) => registrationCount = registrationCount + amount;

  bool hasRegistrationCount() => _registrationCount != null;

  // "maxParticipants" field.
  int? _maxParticipants;
  int get maxParticipants => _maxParticipants ?? 0;
  set maxParticipants(int? val) => _maxParticipants = val;

  void incrementMaxParticipants(int amount) => maxParticipants = maxParticipants + amount;

  bool hasMaxParticipants() => _maxParticipants != null;

  // "startTimestamp" field.
  String? _startTimestamp;
  String get startTimestamp => _startTimestamp ?? '';
  set startTimestamp(String? val) => _startTimestamp = val;

  bool hasStartTimestamp() => _startTimestamp != null;

  // "startIso" field.
  String? _startIso;
  String get startIso => _startIso ?? '';
  set startIso(String? val) => _startIso = val;

  bool hasStartIso() => _startIso != null;

  // "endTimestamp" field.
  String? _endTimestamp;
  String get endTimestamp => _endTimestamp ?? '';
  set endTimestamp(String? val) => _endTimestamp = val;

  bool hasEndTimestamp() => _endTimestamp != null;

  // "endIso" field.
  String? _endIso;
  String get endIso => _endIso ?? '';
  set endIso(String? val) => _endIso = val;

  bool hasEndIso() => _endIso != null;

  // "venue" field.
  VenueStruct? _venue;
  VenueStruct get venue => _venue ?? VenueStruct();
  set venue(VenueStruct? val) => _venue = val;

  void updateVenue(Function(VenueStruct) updateFn) {
    updateFn(_venue ??= VenueStruct());
  }

  bool hasVenue() => _venue != null;

  static EventModelStruct fromMap(Map<String, dynamic> data) => EventModelStruct(
        id: castToType<int>(data['id']),
        index: castToType<int>(data['index']),
        archived: data['archived'] as bool?,
        featured: data['featured'] as bool?,
        hasWebcast: data['hasWebcast'] as bool?,
        webcastUrl: data['webcastUrl'] as String?,
        onlineOnly: data['onlineOnly'] as bool?,
        eventTypeId: castToType<int>(data['eventTypeId']),
        orgId: castToType<int>(data['orgId']),
        name: data['name'] as String?,
        shortDescription: data['shortDescription'] as String?,
        description: data['description'] as String?,
        descriptionText: data['descriptionText'] as String?,
        eventDateId: castToType<int>(data['eventDateId']),
        hasImage1: data['hasImage1'] as bool?,
        requiresRegistration: data['requiresRegistration'] as bool?,
        registrationCount: castToType<int>(data['registrationCount']),
        maxParticipants: castToType<int>(data['maxParticipants']),
        startTimestamp: data['startTimestamp'] as String?,
        startIso: data['startIso'] as String?,
        endTimestamp: data['endTimestamp'] as String?,
        endIso: data['endIso'] as String?,
        venue: data['venue'] is VenueStruct ? data['venue'] : VenueStruct.maybeFromMap(data['venue']),
      );

  static EventModelStruct? maybeFromMap(dynamic data) =>
      data is Map ? EventModelStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'index': _index,
        'archived': _archived,
        'featured': _featured,
        'hasWebcast': _hasWebcast,
        'webcastUrl': _webcastUrl,
        'onlineOnly': _onlineOnly,
        'eventTypeId': _eventTypeId,
        'orgId': _orgId,
        'name': _name,
        'shortDescription': _shortDescription,
        'description': _description,
        'descriptionText': _descriptionText,
        'eventDateId': _eventDateId,
        'hasImage1': _hasImage1,
        'requiresRegistration': _requiresRegistration,
        'registrationCount': _registrationCount,
        'maxParticipants': _maxParticipants,
        'startTimestamp': _startTimestamp,
        'startIso': _startIso,
        'endTimestamp': _endTimestamp,
        'endIso': _endIso,
        'venue': _venue?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'index': serializeParam(
          _index,
          ParamType.int,
        ),
        'archived': serializeParam(
          _archived,
          ParamType.bool,
        ),
        'featured': serializeParam(
          _featured,
          ParamType.bool,
        ),
        'hasWebcast': serializeParam(
          _hasWebcast,
          ParamType.bool,
        ),
        'webcastUrl': serializeParam(
          _webcastUrl,
          ParamType.String,
        ),
        'onlineOnly': serializeParam(
          _onlineOnly,
          ParamType.bool,
        ),
        'eventTypeId': serializeParam(
          _eventTypeId,
          ParamType.int,
        ),
        'orgId': serializeParam(
          _orgId,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'shortDescription': serializeParam(
          _shortDescription,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'descriptionText': serializeParam(
          _descriptionText,
          ParamType.String,
        ),
        'eventDateId': serializeParam(
          _eventDateId,
          ParamType.int,
        ),
        'hasImage1': serializeParam(
          _hasImage1,
          ParamType.bool,
        ),
        'requiresRegistration': serializeParam(
          _requiresRegistration,
          ParamType.bool,
        ),
        'registrationCount': serializeParam(
          _registrationCount,
          ParamType.int,
        ),
        'maxParticipants': serializeParam(
          _maxParticipants,
          ParamType.int,
        ),
        'startTimestamp': serializeParam(
          _startTimestamp,
          ParamType.String,
        ),
        'startIso': serializeParam(
          _startIso,
          ParamType.String,
        ),
        'endTimestamp': serializeParam(
          _endTimestamp,
          ParamType.String,
        ),
        'endIso': serializeParam(
          _endIso,
          ParamType.String,
        ),
        'venue': serializeParam(
          _venue,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static EventModelStruct fromSerializableMap(Map<String, dynamic> data) => EventModelStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        index: deserializeParam(
          data['index'],
          ParamType.int,
          false,
        ),
        archived: deserializeParam(
          data['archived'],
          ParamType.bool,
          false,
        ),
        featured: deserializeParam(
          data['featured'],
          ParamType.bool,
          false,
        ),
        hasWebcast: deserializeParam(
          data['hasWebcast'],
          ParamType.bool,
          false,
        ),
        webcastUrl: deserializeParam(
          data['webcastUrl'],
          ParamType.String,
          false,
        ),
        onlineOnly: deserializeParam(
          data['onlineOnly'],
          ParamType.bool,
          false,
        ),
        eventTypeId: deserializeParam(
          data['eventTypeId'],
          ParamType.int,
          false,
        ),
        orgId: deserializeParam(
          data['orgId'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        shortDescription: deserializeParam(
          data['shortDescription'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        descriptionText: deserializeParam(
          data['descriptionText'],
          ParamType.String,
          false,
        ),
        eventDateId: deserializeParam(
          data['eventDateId'],
          ParamType.int,
          false,
        ),
        hasImage1: deserializeParam(
          data['hasImage1'],
          ParamType.bool,
          false,
        ),
        requiresRegistration: deserializeParam(
          data['requiresRegistration'],
          ParamType.bool,
          false,
        ),
        registrationCount: deserializeParam(
          data['registrationCount'],
          ParamType.int,
          false,
        ),
        maxParticipants: deserializeParam(
          data['maxParticipants'],
          ParamType.int,
          false,
        ),
        startTimestamp: deserializeParam(
          data['startTimestamp'],
          ParamType.String,
          false,
        ),
        startIso: deserializeParam(
          data['startIso'],
          ParamType.String,
          false,
        ),
        endTimestamp: deserializeParam(
          data['endTimestamp'],
          ParamType.String,
          false,
        ),
        endIso: deserializeParam(
          data['endIso'],
          ParamType.String,
          false,
        ),
        venue: deserializeStructParam(
          data['venue'],
          ParamType.DataStruct,
          false,
          structBuilder: VenueStruct.fromSerializableMap,
        ),
      );

  static EventModelStruct fromAlgoliaData(Map<String, dynamic> data) => EventModelStruct(
        id: convertAlgoliaParam(
          data['id'],
          ParamType.int,
          false,
        ),
        index: convertAlgoliaParam(
          data['index'],
          ParamType.int,
          false,
        ),
        archived: convertAlgoliaParam(
          data['archived'],
          ParamType.bool,
          false,
        ),
        featured: convertAlgoliaParam(
          data['featured'],
          ParamType.bool,
          false,
        ),
        hasWebcast: convertAlgoliaParam(
          data['hasWebcast'],
          ParamType.bool,
          false,
        ),
        webcastUrl: convertAlgoliaParam(
          data['webcastUrl'],
          ParamType.String,
          false,
        ),
        onlineOnly: convertAlgoliaParam(
          data['onlineOnly'],
          ParamType.bool,
          false,
        ),
        eventTypeId: convertAlgoliaParam(
          data['eventTypeId'],
          ParamType.int,
          false,
        ),
        orgId: convertAlgoliaParam(
          data['orgId'],
          ParamType.int,
          false,
        ),
        name: convertAlgoliaParam(
          data['name'],
          ParamType.String,
          false,
        ),
        shortDescription: convertAlgoliaParam(
          data['shortDescription'],
          ParamType.String,
          false,
        ),
        description: convertAlgoliaParam(
          data['description'],
          ParamType.String,
          false,
        ),
        descriptionText: convertAlgoliaParam(
          data['descriptionText'],
          ParamType.String,
          false,
        ),
        eventDateId: convertAlgoliaParam(
          data['eventDateId'],
          ParamType.int,
          false,
        ),
        hasImage1: convertAlgoliaParam(
          data['hasImage1'],
          ParamType.bool,
          false,
        ),
        requiresRegistration: convertAlgoliaParam(
          data['requiresRegistration'],
          ParamType.bool,
          false,
        ),
        registrationCount: convertAlgoliaParam(
          data['registrationCount'],
          ParamType.int,
          false,
        ),
        maxParticipants: convertAlgoliaParam(
          data['maxParticipants'],
          ParamType.int,
          false,
        ),
        startTimestamp: convertAlgoliaParam(
          data['startTimestamp'],
          ParamType.String,
          false,
        ),
        startIso: convertAlgoliaParam(
          data['startIso'],
          ParamType.String,
          false,
        ),
        endTimestamp: convertAlgoliaParam(
          data['endTimestamp'],
          ParamType.String,
          false,
        ),
        endIso: convertAlgoliaParam(
          data['endIso'],
          ParamType.String,
          false,
        ),
        venue: convertAlgoliaParam(
          data['venue'],
          ParamType.DataStruct,
          false,
          structBuilder: VenueStruct.fromAlgoliaData,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'EventModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EventModelStruct &&
        id == other.id &&
        index == other.index &&
        archived == other.archived &&
        featured == other.featured &&
        hasWebcast == other.hasWebcast &&
        webcastUrl == other.webcastUrl &&
        onlineOnly == other.onlineOnly &&
        eventTypeId == other.eventTypeId &&
        orgId == other.orgId &&
        name == other.name &&
        shortDescription == other.shortDescription &&
        description == other.description &&
        descriptionText == other.descriptionText &&
        eventDateId == other.eventDateId &&
        hasImage1 == other.hasImage1 &&
        requiresRegistration == other.requiresRegistration &&
        registrationCount == other.registrationCount &&
        maxParticipants == other.maxParticipants &&
        startTimestamp == other.startTimestamp &&
        startIso == other.startIso &&
        endTimestamp == other.endTimestamp &&
        endIso == other.endIso &&
        venue == other.venue;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        index,
        archived,
        featured,
        hasWebcast,
        webcastUrl,
        onlineOnly,
        eventTypeId,
        orgId,
        name,
        shortDescription,
        description,
        descriptionText,
        eventDateId,
        hasImage1,
        requiresRegistration,
        registrationCount,
        maxParticipants,
        startTimestamp,
        startIso,
        endTimestamp,
        endIso,
        venue
      ]);
}

EventModelStruct createEventModelStruct({
  int? id,
  int? index,
  bool? archived,
  bool? featured,
  bool? hasWebcast,
  String? webcastUrl,
  bool? onlineOnly,
  int? eventTypeId,
  int? orgId,
  String? name,
  String? shortDescription,
  String? description,
  String? descriptionText,
  int? eventDateId,
  bool? hasImage1,
  bool? requiresRegistration,
  int? registrationCount,
  int? maxParticipants,
  String? startTimestamp,
  String? startIso,
  String? endTimestamp,
  String? endIso,
  VenueStruct? venue,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EventModelStruct(
      id: id,
      index: index,
      archived: archived,
      featured: featured,
      hasWebcast: hasWebcast,
      webcastUrl: webcastUrl,
      onlineOnly: onlineOnly,
      eventTypeId: eventTypeId,
      orgId: orgId,
      name: name,
      shortDescription: shortDescription,
      description: description,
      descriptionText: descriptionText,
      eventDateId: eventDateId,
      hasImage1: hasImage1,
      requiresRegistration: requiresRegistration,
      registrationCount: registrationCount,
      maxParticipants: maxParticipants,
      startTimestamp: startTimestamp,
      startIso: startIso,
      endTimestamp: endTimestamp,
      endIso: endIso,
      venue: venue ?? (clearUnsetFields ? VenueStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EventModelStruct? updateEventModelStruct(
  EventModelStruct? eventModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    eventModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEventModelStructData(
  Map<String, dynamic> firestoreData,
  EventModelStruct? eventModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (eventModel == null) {
    return;
  }
  if (eventModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && eventModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final eventModelData = getEventModelFirestoreData(eventModel, forFieldValue);
  final nestedData = eventModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = eventModel.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEventModelFirestoreData(
  EventModelStruct? eventModel, [
  bool forFieldValue = false,
]) {
  if (eventModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(eventModel.toMap());

  // Handle nested data for "venue" field.
  addVenueStructData(
    firestoreData,
    eventModel.hasVenue() ? eventModel.venue : null,
    'venue',
    forFieldValue,
  );

  // Add any Firestore field values
  eventModel.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEventModelListFirestoreData(
  List<EventModelStruct>? eventModels,
) =>
    eventModels?.map((e) => getEventModelFirestoreData(e, true)).toList() ?? [];
