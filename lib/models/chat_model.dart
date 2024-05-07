// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatModel {
  final String id;
  final List<String> members;
  final String title;
  final String description;
  final String profilePic;
  final String latest;
  final DateTime createdAt;
  final DateTime lastEditedAt;
  final String type;
  final bool isDM;
  final List<String> permissions;
  ChatModel({
    required this.id,
    required this.members,
    required this.title,
    required this.description,
    required this.profilePic,
    required this.latest,
    required this.createdAt,
    required this.lastEditedAt,
    required this.type,
    required this.isDM,
    required this.permissions,
  });

  ChatModel copyWith({
    String? id,
    List<String>? members,
    String? title,
    String? description,
    String? profilePic,
    String? latest,
    DateTime? createdAt,
    DateTime? lastEditedAt,
    String? type,
    bool? isDM,
    List<String>? permissions,
  }) {
    return ChatModel(
      id: id ?? this.id,
      members: members ?? this.members,
      title: title ?? this.title,
      description: description ?? this.description,
      profilePic: profilePic ?? this.profilePic,
      latest: latest ?? this.latest,
      createdAt: createdAt ?? this.createdAt,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      type: type ?? this.type,
      isDM: isDM ?? this.isDM,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'members': members,
      'title': title,
      'description': description,
      'profilePic': profilePic,
      'latest': latest,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastEditedAt': lastEditedAt.millisecondsSinceEpoch,
      'type': type,
      'isDM': isDM,
      'permissions': permissions,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      members: List<String>.from((map['members'] as List<dynamic>)),
      title: map['title'] as String,
      description: map['description'] as String,
      profilePic: map['profilePic'] as String,
      latest: map['latest'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastEditedAt:
          DateTime.fromMillisecondsSinceEpoch(map['lastEditedAt'] as int),
      type: map['type'] as String,
      isDM: map['isDM'] as bool,
      permissions: List<String>.from((map['permissions'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, members: $members, title: $title, description: $description, profilePic: $profilePic, latest: $latest, createdAt: $createdAt, lastEditedAt: $lastEditedAt, type: $type, isDM: $isDM, permissions: $permissions)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.members, members) &&
        other.title == title &&
        other.description == description &&
        other.profilePic == profilePic &&
        other.latest == latest &&
        other.createdAt == createdAt &&
        other.lastEditedAt == lastEditedAt &&
        other.type == type &&
        other.isDM == isDM &&
        listEquals(other.permissions, permissions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        members.hashCode ^
        title.hashCode ^
        description.hashCode ^
        profilePic.hashCode ^
        latest.hashCode ^
        createdAt.hashCode ^
        lastEditedAt.hashCode ^
        type.hashCode ^
        isDM.hashCode ^
        permissions.hashCode;
  }
}
