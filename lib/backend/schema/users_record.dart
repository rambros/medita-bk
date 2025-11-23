import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "loginType" field.
  String? _loginType;
  String get loginType => _loginType ?? '';
  bool hasLoginType() => _loginType != null;

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  bool hasFullName() => _fullName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "curriculum" field.
  String? _curriculum;
  String get curriculum => _curriculum ?? '';
  bool hasCurriculum() => _curriculum != null;

  // "site" field.
  String? _site;
  String get site => _site ?? '';
  bool hasSite() => _site != null;

  // "contact" field.
  String? _contact;
  String get contact => _contact ?? '';
  bool hasContact() => _contact != null;

  // "favorites" field.
  List<String>? _favorites;
  List<String> get favorites => _favorites ?? const [];
  bool hasFavorites() => _favorites != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "userImageUrl" field.
  String? _userImageUrl;
  String get userImageUrl => _userImageUrl ?? '';
  bool hasUserImageUrl() => _userImageUrl != null;

  // "userImageFileName" field.
  String? _userImageFileName;
  String get userImageFileName => _userImageFileName ?? '';
  bool hasUserImageFileName() => _userImageFileName != null;

  // "playlists" field.
  List<PlaylistModelStruct>? _playlists;
  List<PlaylistModelStruct> get playlists => _playlists ?? const [];
  bool hasPlaylists() => _playlists != null;

  // "desafio21" field.
  D21ModelStruct? _desafio21;
  D21ModelStruct get desafio21 => _desafio21 ?? D21ModelStruct();
  bool hasDesafio21() => _desafio21 != null;

  // "desafio21Started" field.
  bool? _desafio21Started;
  bool get desafio21Started => _desafio21Started ?? false;
  bool hasDesafio21Started() => _desafio21Started != null;

  // "userRole" field.
  List<String>? _userRole;
  List<String> get userRole => _userRole ?? const [];
  bool hasUserRole() => _userRole != null;

  // "lastAccess" field.
  DateTime? _lastAccess;
  DateTime? get lastAccess => _lastAccess;
  bool hasLastAccess() => _lastAccess != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _loginType = snapshotData['loginType'] as String?;
    _fullName = snapshotData['fullName'] as String?;
    _email = snapshotData['email'] as String?;
    _curriculum = snapshotData['curriculum'] as String?;
    _site = snapshotData['site'] as String?;
    _contact = snapshotData['contact'] as String?;
    _favorites = getDataList(snapshotData['favorites']);
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _userImageUrl = snapshotData['userImageUrl'] as String?;
    _userImageFileName = snapshotData['userImageFileName'] as String?;
    _playlists = getStructList(
      snapshotData['playlists'],
      PlaylistModelStruct.fromMap,
    );
    _desafio21 = snapshotData['desafio21'] is D21ModelStruct
        ? snapshotData['desafio21']
        : D21ModelStruct.maybeFromMap(snapshotData['desafio21']);
    _desafio21Started = snapshotData['desafio21Started'] as bool?;
    _userRole = getDataList(snapshotData['userRole']);
    _lastAccess = snapshotData['lastAccess'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? uid,
  String? loginType,
  String? fullName,
  String? email,
  String? curriculum,
  String? site,
  String? contact,
  DateTime? createdTime,
  String? phoneNumber,
  String? photoUrl,
  String? displayName,
  String? userImageUrl,
  String? userImageFileName,
  D21ModelStruct? desafio21,
  bool? desafio21Started,
  DateTime? lastAccess,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'loginType': loginType,
      'fullName': fullName,
      'email': email,
      'curriculum': curriculum,
      'site': site,
      'contact': contact,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'display_name': displayName,
      'userImageUrl': userImageUrl,
      'userImageFileName': userImageFileName,
      'desafio21': D21ModelStruct().toMap(),
      'desafio21Started': desafio21Started,
      'lastAccess': lastAccess,
    }.withoutNulls,
  );

  // Handle nested data for "desafio21" field.
  addD21ModelStructData(firestoreData, desafio21, 'desafio21');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.uid == e2?.uid &&
        e1?.loginType == e2?.loginType &&
        e1?.fullName == e2?.fullName &&
        e1?.email == e2?.email &&
        e1?.curriculum == e2?.curriculum &&
        e1?.site == e2?.site &&
        e1?.contact == e2?.contact &&
        listEquality.equals(e1?.favorites, e2?.favorites) &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.displayName == e2?.displayName &&
        e1?.userImageUrl == e2?.userImageUrl &&
        e1?.userImageFileName == e2?.userImageFileName &&
        listEquality.equals(e1?.playlists, e2?.playlists) &&
        e1?.desafio21 == e2?.desafio21 &&
        e1?.desafio21Started == e2?.desafio21Started &&
        listEquality.equals(e1?.userRole, e2?.userRole) &&
        e1?.lastAccess == e2?.lastAccess;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.loginType,
        e?.fullName,
        e?.email,
        e?.curriculum,
        e?.site,
        e?.contact,
        e?.favorites,
        e?.createdTime,
        e?.phoneNumber,
        e?.photoUrl,
        e?.displayName,
        e?.userImageUrl,
        e?.userImageFileName,
        e?.playlists,
        e?.desafio21,
        e?.desafio21Started,
        e?.userRole,
        e?.lastAccess
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
