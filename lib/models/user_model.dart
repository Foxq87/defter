import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String uid;
  final String username;
  final String username_insensitive;
  final String name;
  final String name_insensitive;
  final String profilePic;
  final String schoolId;
  final String email;
  final String banner;
  final String bio;
  final int warningCount;
  final bool isSuspended;
  final bool didAcceptEula;
  final DateTime creation;
  final List<String> blockedAccountIds;
  final List<String> roles;
  final List<String> followers;
  final List<String> following;
  final List<String> ofCloseFriends;
  final List<String> closeFriends;
  UserModel({
    required this.uid,
    required this.username,
    required this.username_insensitive,
    required this.name,
    required this.name_insensitive,
    required this.profilePic,
    required this.schoolId,
    required this.email,
    required this.banner,
    required this.bio,
    required this.warningCount,
    required this.isSuspended,
    required this.didAcceptEula,
    required this.creation,
    required this.blockedAccountIds,
    required this.roles,
    required this.followers,
    required this.following,
    required this.ofCloseFriends,
    required this.closeFriends,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? username_insensitive,
    String? name,
    String? name_insensitive,
    String? profilePic,
    String? schoolId,
    String? email,
    String? banner,
    String? bio,
    int? warningCount,
    bool? isSuspended,
    bool? didAcceptEula,
    DateTime? creation,
    List<String>? blockedAccountIds,
    List<String>? roles,
    List<String>? followers,
    List<String>? following,
    List<String>? ofCloseFriends,
    List<String>? closeFriends,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      username_insensitive: username_insensitive ?? this.username_insensitive,
      name: name ?? this.name,
      name_insensitive: name_insensitive ?? this.name_insensitive,
      profilePic: profilePic ?? this.profilePic,
      schoolId: schoolId ?? this.schoolId,
      email: email ?? this.email,
      banner: banner ?? this.banner,
      bio: bio ?? this.bio,
      warningCount: warningCount ?? this.warningCount,
      isSuspended: isSuspended ?? this.isSuspended,
      didAcceptEula: didAcceptEula ?? this.didAcceptEula,
      creation: creation ?? this.creation,
      blockedAccountIds: blockedAccountIds ?? this.blockedAccountIds,
      roles: roles ?? this.roles,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      ofCloseFriends: ofCloseFriends ?? this.ofCloseFriends,
      closeFriends: closeFriends ?? this.closeFriends,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'username_insensitive': username_insensitive,
      'name': name,
      'name_insensitive': name_insensitive,
      'profilePic': profilePic,
      'schoolId': schoolId,
      'email': email,
      'banner': banner,
      'bio': bio,
      'warningCount': warningCount,
      'isSuspended': isSuspended,
      'didAcceptEula': didAcceptEula,
      'creation': creation.millisecondsSinceEpoch,
      'blockedAccountIds': blockedAccountIds,
      'roles': roles,
      'followers': followers,
      'following': following,
      'ofCloseFriends': ofCloseFriends,
      'closeFriends': closeFriends,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      username_insensitive: map['username_insensitive'] as String,
      name: map['name'] as String,
      name_insensitive: map['name_insensitive'] as String,
      profilePic: map['profilePic'] as String,
      schoolId: map['schoolId'] as String,
      email: map['email'] as String,
      banner: map['banner'] as String,
      bio: map['bio'] as String,
      warningCount: map['warningCount'] as int,
      isSuspended: map['isSuspended'] as bool,
      didAcceptEula: map['didAcceptEula'] as bool,
      creation: DateTime.fromMillisecondsSinceEpoch(map['creation'] as int),
      blockedAccountIds: List<String>.from((map['blockedAccountIds'] as List<dynamic>)),
      roles: List<String>.from((map['roles'] as List<dynamic>)),
      followers: List<String>.from((map['followers'] as List<dynamic>)),
      following: List<String>.from((map['following'] as List<dynamic>)),
      ofCloseFriends: List<String>.from((map['ofCloseFriends'] as List<dynamic>)),
      closeFriends: List<String>.from((map['closeFriends'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, username_insensitive: $username_insensitive, name: $name, name_insensitive: $name_insensitive, profilePic: $profilePic, schoolId: $schoolId, email: $email, banner: $banner, bio: $bio, warningCount: $warningCount, isSuspended: $isSuspended, didAcceptEula: $didAcceptEula, creation: $creation, blockedAccountIds: $blockedAccountIds, roles: $roles, followers: $followers, following: $following, ofCloseFriends: $ofCloseFriends, closeFriends: $closeFriends)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.username == username &&
      other.username_insensitive == username_insensitive &&
      other.name == name &&
      other.name_insensitive == name_insensitive &&
      other.profilePic == profilePic &&
      other.schoolId == schoolId &&
      other.email == email &&
      other.banner == banner &&
      other.bio == bio &&
      other.warningCount == warningCount &&
      other.isSuspended == isSuspended &&
      other.didAcceptEula == didAcceptEula &&
      other.creation == creation &&
      listEquals(other.blockedAccountIds, blockedAccountIds) &&
      listEquals(other.roles, roles) &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      listEquals(other.ofCloseFriends, ofCloseFriends) &&
      listEquals(other.closeFriends, closeFriends);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      username.hashCode ^
      username_insensitive.hashCode ^
      name.hashCode ^
      name_insensitive.hashCode ^
      profilePic.hashCode ^
      schoolId.hashCode ^
      email.hashCode ^
      banner.hashCode ^
      bio.hashCode ^
      warningCount.hashCode ^
      isSuspended.hashCode ^
      didAcceptEula.hashCode ^
      creation.hashCode ^
      blockedAccountIds.hashCode ^
      roles.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      ofCloseFriends.hashCode ^
      closeFriends.hashCode;
  }
}
