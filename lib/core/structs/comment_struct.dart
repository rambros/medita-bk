// ignore_for_file: unnecessary_getters_setters
import 'package:medita_b_k/utils/algolia_serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:medita_b_k/core/structs/util/firestore_util.dart';

import 'package:medita_b_k/ui/core/flutter_flow/flutter_flow_util.dart';

class CommentStruct extends FFFirebaseStruct {
  CommentStruct({
    String? userId,
    String? userName,
    String? comment,
    String? commentDate,
    String? userImageUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _userId = userId,
        _userName = userName,
        _comment = comment,
        _commentDate = commentDate,
        _userImageUrl = userImageUrl,
        super(firestoreUtilData);

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "userName" field.
  String? _userName;
  String get userName => _userName ?? '';
  set userName(String? val) => _userName = val;

  bool hasUserName() => _userName != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  set comment(String? val) => _comment = val;

  bool hasComment() => _comment != null;

  // "commentDate" field.
  String? _commentDate;
  String get commentDate => _commentDate ?? '';
  set commentDate(String? val) => _commentDate = val;

  bool hasCommentDate() => _commentDate != null;

  // "userImageUrl" field.
  String? _userImageUrl;
  String get userImageUrl => _userImageUrl ?? '';
  set userImageUrl(String? val) => _userImageUrl = val;

  bool hasUserImageUrl() => _userImageUrl != null;

  static CommentStruct fromMap(Map<String, dynamic> data) => CommentStruct(
        userId: data['userId'] as String?,
        userName: data['userName'] as String?,
        comment: data['comment'] as String?,
        commentDate: data['commentDate'] as String?,
        userImageUrl: data['userImageUrl'] as String?,
      );

  static CommentStruct? maybeFromMap(dynamic data) =>
      data is Map ? CommentStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'userId': _userId,
        'userName': _userName,
        'comment': _comment,
        'commentDate': _commentDate,
        'userImageUrl': _userImageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'userId': serializeParam(
          _userId,
          ParamType.String,
        ),
        'userName': serializeParam(
          _userName,
          ParamType.String,
        ),
        'comment': serializeParam(
          _comment,
          ParamType.String,
        ),
        'commentDate': serializeParam(
          _commentDate,
          ParamType.String,
        ),
        'userImageUrl': serializeParam(
          _userImageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static CommentStruct fromSerializableMap(Map<String, dynamic> data) => CommentStruct(
        userId: deserializeParam(
          data['userId'],
          ParamType.String,
          false,
        ),
        userName: deserializeParam(
          data['userName'],
          ParamType.String,
          false,
        ),
        comment: deserializeParam(
          data['comment'],
          ParamType.String,
          false,
        ),
        commentDate: deserializeParam(
          data['commentDate'],
          ParamType.String,
          false,
        ),
        userImageUrl: deserializeParam(
          data['userImageUrl'],
          ParamType.String,
          false,
        ),
      );

  static CommentStruct fromAlgoliaData(Map<String, dynamic> data) => CommentStruct(
        userId: convertAlgoliaParam(
          data['userId'],
          ParamType.String,
          false,
        ),
        userName: convertAlgoliaParam(
          data['userName'],
          ParamType.String,
          false,
        ),
        comment: convertAlgoliaParam(
          data['comment'],
          ParamType.String,
          false,
        ),
        commentDate: convertAlgoliaParam(
          data['commentDate'],
          ParamType.String,
          false,
        ),
        userImageUrl: convertAlgoliaParam(
          data['userImageUrl'],
          ParamType.String,
          false,
        ),
        firestoreUtilData: const FirestoreUtilData(
          clearUnsetFields: false,
          create: true,
        ),
      );

  @override
  String toString() => 'CommentStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CommentStruct &&
        userId == other.userId &&
        userName == other.userName &&
        comment == other.comment &&
        commentDate == other.commentDate &&
        userImageUrl == other.userImageUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([userId, userName, comment, commentDate, userImageUrl]);
}

CommentStruct createCommentStruct({
  String? userId,
  String? userName,
  String? comment,
  String? commentDate,
  String? userImageUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CommentStruct(
      userId: userId,
      userName: userName,
      comment: comment,
      commentDate: commentDate,
      userImageUrl: userImageUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CommentStruct? updateCommentStruct(
  CommentStruct? commentStruct, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    commentStruct
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCommentStructData(
  Map<String, dynamic> firestoreData,
  CommentStruct? commentStruct,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (commentStruct == null) {
    return;
  }
  if (commentStruct.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && commentStruct.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final commentStructData = getCommentFirestoreData(commentStruct, forFieldValue);
  final nestedData = commentStructData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = commentStruct.firestoreUtilData.create || clearFields;
  firestoreData.addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCommentFirestoreData(
  CommentStruct? commentStruct, [
  bool forFieldValue = false,
]) {
  if (commentStruct == null) {
    return {};
  }
  final firestoreData = mapToFirestore(commentStruct.toMap());

  // Add any Firestore field values
  commentStruct.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCommentListFirestoreData(
  List<CommentStruct>? commentStructs,
) =>
    commentStructs?.map((e) => getCommentFirestoreData(e, true)).toList() ?? [];
