// ignore_for_file: unnecessary_getters_setters
import '/backend/algolia/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/ui/core/flutter_flow/flutter_flow_util.dart';

class VenueStruct extends FFFirebaseStruct {
  VenueStruct({
    int? id,
    String? name,
    String? address,
    String? postalCode,
    String? locality,
    String? country,
    String? email,
    String? phone,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _name = name,
        _address = address,
        _postalCode = postalCode,
        _locality = locality,
        _country = country,
        _email = email,
        _phone = phone,
        super(firestoreUtilData);

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "postalCode" field.
  String? _postalCode;
  String get postalCode => _postalCode ?? '';
  set postalCode(String? val) => _postalCode = val;

  bool hasPostalCode() => _postalCode != null;

  // "locality" field.
  String? _locality;
  String get locality => _locality ?? '';
  set locality(String? val) => _locality = val;

  bool hasLocality() => _locality != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  static VenueStruct fromMap(Map<String, dynamic> data) => VenueStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        address: data['address'] as String?,
        postalCode: data['postalCode'] as String?,
        locality: data['locality'] as String?,
        country: data['country'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
      );

  static VenueStruct? maybeFromMap(dynamic data) =>
      data is Map ? VenueStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'address': _address,
        'postalCode': _postalCode,
        'locality': _locality,
        'country': _country,
        'email': _email,
        'phone': _phone,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'postalCode': serializeParam(
          _postalCode,
          ParamType.String,
        ),
        'locality': serializeParam(
          _locality,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
      }.withoutNulls;

  static VenueStruct fromSerializableMap(Map<String, dynamic> data) =>
      VenueStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        postalCode: deserializeParam(
          data['postalCode'],
          ParamType.String,
          false,
        ),
        locality: deserializeParam(
          data['locality'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
      );

  static VenueStruct fromAlgoliaData(Map<String, dynamic> data) => VenueStruct(
        id: convertAlgoliaParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: convertAlgoliaParam(
          data['name'],
          ParamType.String,
          false,
        ),
        address: convertAlgoliaParam(
          data['address'],
          ParamType.String,
          false,
        ),
        postalCode: convertAlgoliaParam(
          data['postalCode'],
          ParamType.String,
          false,
        ),
        locality: convertAlgoliaParam(
          data['locality'],
          ParamType.String,
          false,
        ),
        country: convertAlgoliaParam(
          data['country'],
          ParamType.String,
          false,
        ),
        email: convertAlgoliaParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: convertAlgoliaParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'VenueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VenueStruct &&
        id == other.id &&
        name == other.name &&
        address == other.address &&
        postalCode == other.postalCode &&
        locality == other.locality &&
        country == other.country &&
        email == other.email &&
        phone == other.phone;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, name, address, postalCode, locality, country, email, phone]);
}

VenueStruct createVenueStruct({
  int? id,
  String? name,
  String? address,
  String? postalCode,
  String? locality,
  String? country,
  String? email,
  String? phone,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    VenueStruct(
      id: id,
      name: name,
      address: address,
      postalCode: postalCode,
      locality: locality,
      country: country,
      email: email,
      phone: phone,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

VenueStruct? updateVenueStruct(
  VenueStruct? venue, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    venue
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addVenueStructData(
  Map<String, dynamic> firestoreData,
  VenueStruct? venue,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (venue == null) {
    return;
  }
  if (venue.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && venue.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final venueData = getVenueFirestoreData(venue, forFieldValue);
  final nestedData = venueData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = venue.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getVenueFirestoreData(
  VenueStruct? venue, [
  bool forFieldValue = false,
]) {
  if (venue == null) {
    return {};
  }
  final firestoreData = mapToFirestore(venue.toMap());

  // Add any Firestore field values
  venue.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getVenueListFirestoreData(
  List<VenueStruct>? venues,
) =>
    venues?.map((e) => getVenueFirestoreData(e, true)).toList() ?? [];
