// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChatModel {
  final String id;
  final String title;
  final String description;
  final String profilePic;
  final String latest;
  final String type;
  final bool isDM;
  final bool isHidden;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime lastEditedAt;
  final List<String> permissions;
  final List<String> members;
  ChatModel({
    required this.id,
    required this.title,
    required this.description,
    required this.profilePic,
    required this.latest,
    required this.type,
    required this.isDM,
    required this.isHidden,
    required this.isArchived,
    required this.createdAt,
    required this.lastEditedAt,
    required this.permissions,
    required this.members,
  });

  ChatModel copyWith({
    String? id,
    String? title,
    String? description,
    String? profilePic,
    String? latest,
    String? type,
    bool? isDM,
    bool? isHidden,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? lastEditedAt,
    List<String>? permissions,
    List<String>? members,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      profilePic: profilePic ?? this.profilePic,
      latest: latest ?? this.latest,
      type: type ?? this.type,
      isDM: isDM ?? this.isDM,
      isHidden: isHidden ?? this.isHidden,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      permissions: permissions ?? this.permissions,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'profilePic': profilePic,
      'latest': latest,
      'type': type,
      'isDM': isDM,
      'isHidden': isHidden,
      'isArchived': isArchived,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastEditedAt': lastEditedAt.millisecondsSinceEpoch,
      'permissions': permissions,
      'members': members,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      profilePic: map['profilePic'] as String,
      latest: map['latest'] as String,
      type: map['type'] as String,
      isDM: map['isDM'] as bool,
      isHidden: map['isHidden'] as bool,
      isArchived: map['isArchived'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastEditedAt:
          DateTime.fromMillisecondsSinceEpoch(map['lastEditedAt'] as int),
      permissions: List<String>.from((map['permissions'] as List<dynamic>)),
      members: List<String>.from((map['members'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, title: $title, description: $description, profilePic: $profilePic, latest: $latest, type: $type, isDM: $isDM, isHidden: $isHidden, isArchived: $isArchived, createdAt: $createdAt, lastEditedAt: $lastEditedAt, permissions: $permissions, members: $members)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.profilePic == profilePic &&
        other.latest == latest &&
        other.type == type &&
        other.isDM == isDM &&
        other.isHidden == isHidden &&
        other.isArchived == isArchived &&
        other.createdAt == createdAt &&
        other.lastEditedAt == lastEditedAt &&
        listEquals(other.permissions, permissions) &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        profilePic.hashCode ^
        latest.hashCode ^
        type.hashCode ^
        isDM.hashCode ^
        isHidden.hashCode ^
        isArchived.hashCode ^
        createdAt.hashCode ^
        lastEditedAt.hashCode ^
        permissions.hashCode ^
        members.hashCode;
  }
}
