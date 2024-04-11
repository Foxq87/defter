import 'dart:convert';
import 'package:flutter/foundation.dart';

class Update {
  final String id;
  final String uid;
  final String title;
  final String description;
  final List<String> imageLinks;
  final DateTime creation;
  final List<Reaction> reactions;
  Update({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.imageLinks,
    required this.creation,
    this.reactions = const [],
  });

  Update copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    List<String>? imageLinks,
    DateTime? creation,
    List<Reaction>? reactions,
  }) {
    return Update(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      imageLinks: imageLinks ?? this.imageLinks,
      creation: creation ?? this.creation,
      reactions: reactions ?? this.reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'imageLinks': imageLinks,
      'creation': creation.millisecondsSinceEpoch,
      'reactions': reactions.map((x) => x.toMap()).toList(),
    };
  }

  factory Update.fromMap(Map<String, dynamic> map) {
    return Update(
      id: map['id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      creation: DateTime.fromMillisecondsSinceEpoch(map['creation'] as int),
      reactions: List<Reaction>.from(
        (map['reactions'] as List<dynamic>).map<Reaction>(
          (x) => Reaction.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Update.fromJson(String source) =>
      Update.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Update(id: $id, uid: $uid, title: $title, description: $description, imageLinks: $imageLinks, creation: $creation, reactions: $reactions)';
  }

  @override
  bool operator ==(covariant Update other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        listEquals(other.imageLinks, imageLinks) &&
        other.creation == creation &&
        listEquals(other.reactions, reactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imageLinks.hashCode ^
        creation.hashCode ^
        reactions.hashCode;
  }
}

class Reaction {
  final String userId;
  final String reactionType;

  Reaction({
    required this.userId,
    required this.reactionType,
  });

  Reaction copyWith({
    String? userId,
    String? reactionType,
  }) {
    return Reaction(
      userId: userId ?? this.userId,
      reactionType: reactionType ?? this.reactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'reactionType': reactionType,
    };
  }

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      userId: map['userId'] as String,
      reactionType: map['reactionType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reaction.fromJson(String source) =>
      Reaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Reaction(userId: $userId, reactionType: $reactionType)';

  @override
  bool operator ==(covariant Reaction other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.reactionType == reactionType;
  }

  @override
  int get hashCode => userId.hashCode ^ reactionType.hashCode;
}
