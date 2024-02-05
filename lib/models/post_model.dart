// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String schoolProfilePic;
  final String link;
  final String content;
  final String schoolName;
  final List<String> imageLinks;
  final List<String> likes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  Post({
    required this.id,
    required this.schoolProfilePic,
    required this.link,
    required this.content,
    required this.schoolName,
    required this.imageLinks,
    required this.likes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
  });

  Post copyWith({
    String? id,
    String? schoolProfilePic,
    String? link,
    String? content,
    String? schoolName,
    List<String>? imageLinks,
    List<String>? likes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      schoolProfilePic: schoolProfilePic ?? this.schoolProfilePic,
      link: link ?? this.link,
      content: content ?? this.content,
      schoolName: schoolName ?? this.schoolName,
      imageLinks: imageLinks ?? this.imageLinks,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'schoolProfilePic': schoolProfilePic,
      'link': link,
      'content': content,
      'schoolName': schoolName,
      'imageLinks': imageLinks,
      'likes': likes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      schoolProfilePic: map['schoolProfilePic'] as String,
      link: map['link'] as String,
      content: map['content'] as String,
      schoolName: map['schoolName'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, schoolProfilePic: $schoolProfilePic, link: $link, content: $content, schoolName: $schoolName, imageLinks: $imageLinks, likes: $likes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.schoolProfilePic == schoolProfilePic &&
        other.link == link &&
        other.content == content &&
        other.schoolName == schoolName &&
        listEquals(other.imageLinks, imageLinks) &&
        listEquals(other.likes, likes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        schoolProfilePic.hashCode ^
        link.hashCode ^
        content.hashCode ^
        schoolName.hashCode ^
        imageLinks.hashCode ^
        likes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode;
  }
}
