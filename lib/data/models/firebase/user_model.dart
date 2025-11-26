import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/core/structs/playlist_model_struct.dart';
import '/core/structs/d21_model_struct.dart';
import '/core/structs/util/firestore_util.dart';

/// User data model for Firebase Firestore
///
/// This is a pure Dart model (DTO) that represents user data
/// without any FlutterFlow dependencies.
class UserModel extends Equatable {
  final String uid;
  final String loginType;
  final String fullName;
  final String email;
  final String curriculum;
  final String site;
  final String contact;
  final List<String> favorites;
  final DateTime? createdTime;
  final String phoneNumber;
  final String photoUrl;
  final String displayName;
  final String userImageUrl;
  final String userImageFileName;
  final List<PlaylistModelStruct> playlists;
  final D21ModelStruct? desafio21;
  final bool desafio21Started;
  final List<String> userRole;
  final DateTime? lastAccess;

  const UserModel({
    required this.uid,
    this.loginType = '',
    this.fullName = '',
    this.email = '',
    this.curriculum = '',
    this.site = '',
    this.contact = '',
    this.favorites = const [],
    this.createdTime,
    this.phoneNumber = '',
    this.photoUrl = '',
    this.displayName = '',
    this.userImageUrl = '',
    this.userImageFileName = '',
    this.playlists = const [],
    this.desafio21,
    this.desafio21Started = false,
    this.userRole = const [],
    this.lastAccess,
  });

  // ========== FIRESTORE SERIALIZATION ==========

  /// Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return UserModel(
      uid: data['uid'] as String? ?? '',
      loginType: data['loginType'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      curriculum: data['curriculum'] as String? ?? '',
      site: data['site'] as String? ?? '',
      contact: data['contact'] as String? ?? '',
      favorites: _getStringList(data['favorites']),
      createdTime: _getDateTime(data['created_time']),
      phoneNumber: data['phone_number'] as String? ?? '',
      photoUrl: data['photo_url'] as String? ?? '',
      displayName: data['display_name'] as String? ?? '',
      userImageUrl: data['userImageUrl'] as String? ?? '',
      userImageFileName: data['userImageFileName'] as String? ?? '',
      playlists: _getPlaylistList(data['playlists']),
      desafio21: _getDesafio21(data['desafio21']),
      desafio21Started: data['desafio21Started'] as bool? ?? false,
      userRole: _getStringList(data['userRole']),
      lastAccess: _getDateTime(data['lastAccess']),
    );
  }

  /// Convert UserModel to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'loginType': loginType,
      'fullName': fullName,
      'email': email,
      'curriculum': curriculum,
      'site': site,
      'contact': contact,
      'favorites': favorites,
      'created_time': createdTime != null ? Timestamp.fromDate(createdTime!) : null,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'display_name': displayName,
      'userImageUrl': userImageUrl,
      'userImageFileName': userImageFileName,
      'playlists': playlists.map((p) => p.toMap()).toList(),
      'desafio21': desafio21?.toMap(),
      'desafio21Started': desafio21Started,
      'userRole': userRole,
      'lastAccess': lastAccess != null ? Timestamp.fromDate(lastAccess!) : null,
    };
  }

  // ========== JSON SERIALIZATION (for local storage, API, etc.) ==========

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      loginType: json['loginType'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      curriculum: json['curriculum'] as String? ?? '',
      site: json['site'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      favorites: _getStringList(json['favorites']),
      createdTime: json['createdTime'] != null ? DateTime.parse(json['createdTime']) : null,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      userImageUrl: json['userImageUrl'] as String? ?? '',
      userImageFileName: json['userImageFileName'] as String? ?? '',
      playlists: _getPlaylistList(json['playlists']),
      desafio21: json['desafio21'] != null ? D21ModelStruct.maybeFromMap(json['desafio21']) : null,
      desafio21Started: json['desafio21Started'] as bool? ?? false,
      userRole: _getStringList(json['userRole']),
      lastAccess: json['lastAccess'] != null ? DateTime.parse(json['lastAccess']) : null,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'loginType': loginType,
      'fullName': fullName,
      'email': email,
      'curriculum': curriculum,
      'site': site,
      'contact': contact,
      'favorites': favorites,
      'createdTime': createdTime?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'userImageUrl': userImageUrl,
      'userImageFileName': userImageFileName,
      'playlists': playlists.map((p) => p.toMap()).toList(),
      'desafio21': desafio21?.toMap(),
      'desafio21Started': desafio21Started,
      'userRole': userRole,
      'lastAccess': lastAccess?.toIso8601String(),
    };
  }

  // ========== HELPER METHODS ==========

  static List<String> _getStringList(dynamic data) {
    if (data == null) return const [];
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return const [];
  }

  static DateTime? _getDateTime(dynamic data) {
    if (data == null) return null;
    if (data is Timestamp) return data.toDate();
    if (data is DateTime) return data;
    return null;
  }

  static List<PlaylistModelStruct> _getPlaylistList(dynamic data) {
    if (data == null) return const [];
    if (data is List) {
      return data
          .map((item) {
            if (item is Map<String, dynamic>) {
              return PlaylistModelStruct.maybeFromMap(item);
            }
            return null;
          })
          .whereType<PlaylistModelStruct>()
          .toList();
    }
    return const [];
  }

  static D21ModelStruct? _getDesafio21(dynamic data) {
    if (data == null) return null;
    if (data is D21ModelStruct) return data;
    if (data is Map<String, dynamic>) {
      final parsed = mapFromFirestore(Map<String, dynamic>.from(data));
      return D21ModelStruct.maybeFromMap(parsed);
    }
    return null;
  }

  // ========== COPYWIDTH FOR IMMUTABILITY ==========

  UserModel copyWith({
    String? uid,
    String? loginType,
    String? fullName,
    String? email,
    String? curriculum,
    String? site,
    String? contact,
    List<String>? favorites,
    DateTime? createdTime,
    String? phoneNumber,
    String? photoUrl,
    String? displayName,
    String? userImageUrl,
    String? userImageFileName,
    List<PlaylistModelStruct>? playlists,
    D21ModelStruct? desafio21,
    bool? desafio21Started,
    List<String>? userRole,
    DateTime? lastAccess,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      loginType: loginType ?? this.loginType,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      curriculum: curriculum ?? this.curriculum,
      site: site ?? this.site,
      contact: contact ?? this.contact,
      favorites: favorites ?? this.favorites,
      createdTime: createdTime ?? this.createdTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      userImageFileName: userImageFileName ?? this.userImageFileName,
      playlists: playlists ?? this.playlists,
      desafio21: desafio21 ?? this.desafio21,
      desafio21Started: desafio21Started ?? this.desafio21Started,
      userRole: userRole ?? this.userRole,
      lastAccess: lastAccess ?? this.lastAccess,
    );
  }

  // ========== EQUATABLE ==========

  @override
  List<Object?> get props => [
        uid,
        loginType,
        fullName,
        email,
        curriculum,
        site,
        contact,
        favorites,
        createdTime,
        phoneNumber,
        photoUrl,
        displayName,
        userImageUrl,
        userImageFileName,
        playlists,
        desafio21,
        desafio21Started,
        userRole,
        lastAccess,
      ];

  @override
  bool get stringify => true;
}
