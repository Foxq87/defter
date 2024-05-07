// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Note {
  final String id;
  final String link;
  final String content;
  final String schoolName;
  final List<String> imageLinks;
  final List<String> likes;
  final List<String> bookmarks;
  final int commentCount;
  final String uid;
  final String type;
  final String repliedTo;
  final DateTime createdAt;
  Note({
    required this.id,
    required this.link,
    required this.content,
    required this.schoolName,
    required this.imageLinks,
    required this.likes,
    required this.bookmarks,
    required this.commentCount,
    required this.uid,
    required this.type,
    required this.repliedTo,
    required this.createdAt,
  });

  Note copyWith({
    String? id,
    String? link,
    String? content,
    String? schoolName,
    List<String>? imageLinks,
    List<String>? likes,
    List<String>? bookmarks,
    int? commentCount,
    String? uid,
    String? type,
    String? repliedTo,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      link: link ?? this.link,
      content: content ?? this.content,
      schoolName: schoolName ?? this.schoolName,
      imageLinks: imageLinks ?? this.imageLinks,
      likes: likes ?? this.likes,
      bookmarks: bookmarks ?? this.bookmarks,
      commentCount: commentCount ?? this.commentCount,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      repliedTo: repliedTo ?? this.repliedTo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'link': link,
      'content': content,
      'schoolName': schoolName,
      'imageLinks': imageLinks,
      'likes': likes,
      'bookmarks': bookmarks,
      'commentCount': commentCount,
      'uid': uid,
      'type': type,
      'repliedTo': repliedTo,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      link: map['link'] as String,
      content: map['content'] as String,
      schoolName: map['schoolName'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      bookmarks: List<String>.from((map['bookmarks'] as List<dynamic>)),
      commentCount: map['commentCount'] as int,
      uid: map['uid'] as String,
      type: map['type'] as String,
      repliedTo: map['repliedTo'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Note(id: $id, link: $link, content: $content, schoolName: $schoolName, imageLinks: $imageLinks, likes: $likes, bookmarks: $bookmarks, commentCount: $commentCount, uid: $uid, type: $type, repliedTo: $repliedTo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.link == link &&
      other.content == content &&
      other.schoolName == schoolName &&
      listEquals(other.imageLinks, imageLinks) &&
      listEquals(other.likes, likes) &&
      listEquals(other.bookmarks, bookmarks) &&
      other.commentCount == commentCount &&
      other.uid == uid &&
      other.type == type &&
      other.repliedTo == repliedTo &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      link.hashCode ^
      content.hashCode ^
      schoolName.hashCode ^
      imageLinks.hashCode ^
      likes.hashCode ^
      bookmarks.hashCode ^
      commentCount.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      repliedTo.hashCode ^
      createdAt.hashCode;
  }
}
