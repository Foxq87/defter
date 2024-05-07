// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MessageModel {
  final String id;
  final String uid;
  final String text;
  final String chatId;
  final String link;
  final DateTime createdAt;
  final List<String> imageUrls;
  final List<String> seenBy;
  final List<Map<String, dynamic>> reactions;
  MessageModel({
    required this.id,
    required this.uid,
    required this.text,
    required this.chatId,
    required this.link,
    required this.createdAt,
    required this.imageUrls,
    required this.seenBy,
    required this.reactions,
  });

  MessageModel copyWith({
    String? id,
    String? uid,
    String? text,
    String? chatId,
    String? link,
    DateTime? createdAt,
    List<String>? imageUrls,
    List<String>? seenBy,
    List<Map<String, dynamic>>? reactions,
  }) {
    return MessageModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      text: text ?? this.text,
      chatId: chatId ?? this.chatId,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      seenBy: seenBy ?? this.seenBy,
      reactions: reactions ?? this.reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'text': text,
      'chatId': chatId,
      'link': link,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'imageUrls': imageUrls,
      'seenBy': seenBy,
      'reactions': reactions,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      text: map['text'] as String,
      chatId: map['chatId'] as String,
      link: map['link'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>)),
      seenBy: List<String>.from((map['seenBy'] as List<dynamic>)),
      reactions: List<Map<String, dynamic>>.from(
        (map['reactions'] as List<dynamic>).map<dynamic>(
          (x) => x,
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, uid: $uid, text: $text, chatId: $chatId, link: $link, createdAt: $createdAt, imageUrls: $imageUrls, seenBy: $seenBy, reactions: $reactions)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.text == text &&
        other.chatId == chatId &&
        other.link == link &&
        other.createdAt == createdAt &&
        listEquals(other.imageUrls, imageUrls) &&
        listEquals(other.seenBy, seenBy) &&
        listEquals(other.reactions, reactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        text.hashCode ^
        chatId.hashCode ^
        link.hashCode ^
        createdAt.hashCode ^
        imageUrls.hashCode ^
        seenBy.hashCode ^
        reactions.hashCode;
  }
}
