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
  final bool isSuspended;
  final DateTime creation;
  final List<String> roles;
  final List<String> followers;
  final List<String> following;
  //add creation

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
    required this.isSuspended,
    required this.creation,
    required this.roles,
    required this.followers,
    required this.following,
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
    bool? isSuspended,
    DateTime? creation,
    List<String>? roles,
    List<String>? followers,
    List<String>? following,
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
      isSuspended: isSuspended ?? this.isSuspended,
      creation: creation ?? this.creation,
      roles: roles ?? this.roles,
      followers: followers ?? this.followers,
      following: following ?? this.following,
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
      'isSuspended': isSuspended,
      'creation': creation.millisecondsSinceEpoch,
      'roles': roles,
      'followers': followers,
      'following': following,
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
      isSuspended: map['isSuspended'] as bool,
      creation: DateTime.fromMillisecondsSinceEpoch(map['creation'] as int),
      roles: List<String>.from((map['roles'] as List<dynamic>)),
      followers: List<String>.from((map['followers'] as List<dynamic>)),
      following: List<String>.from((map['following'] as List<dynamic>)),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, username_insensitive: $username_insensitive, name: $name, name_insensitive: $name_insensitive, profilePic: $profilePic, schoolId: $schoolId, email: $email, banner: $banner, bio: $bio, isSuspended: $isSuspended, creation: $creation, roles: $roles, followers: $followers, following: $following)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.username_insensitive == username_insensitive &&
        other.name == name &&
        other.name_insensitive == name_insensitive &&
        other.profilePic == profilePic &&
        other.schoolId == schoolId &&
        other.email == email &&
        other.banner == banner &&
        other.bio == bio &&
        other.isSuspended == isSuspended &&
        other.creation == creation &&
        listEquals(other.roles, roles) &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following);
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
        isSuspended.hashCode ^
        creation.hashCode ^
        roles.hashCode ^
        followers.hashCode ^
        following.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
