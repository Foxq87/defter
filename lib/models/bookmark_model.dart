// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookmarkModel {
  final String uid;
  final String id;
  final String? noteId;
  final String? productId;
  final String? articleId;
  BookmarkModel({
    required this.uid,
    required this.id,
    this.noteId,
    this.productId,
    this.articleId,
  });

  BookmarkModel copyWith({
    String? uid,
    String? id,
    String? noteId,
    String? productId,
    String? articleId,
  }) {
    return BookmarkModel(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      productId: productId ?? this.productId,
      articleId: articleId ?? this.articleId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'id': id,
      'noteId': noteId,
      'productId': productId,
      'articleId': articleId,
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      uid: map['uid'] as String,
      id: map['id'] as String,
      noteId: map['noteId'] != null ? map['noteId'] as String : null,
      productId: map['productId'] != null ? map['productId'] as String : null,
      articleId: map['articleId'] != null ? map['articleId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookmarkModel.fromJson(String source) => BookmarkModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookmarkModel(uid: $uid, id: $id, noteId: $noteId, productId: $productId, articleId: $articleId)';
  }

  @override
  bool operator ==(covariant BookmarkModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.id == id &&
      other.noteId == noteId &&
      other.productId == productId &&
      other.articleId == articleId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      id.hashCode ^
      noteId.hashCode ^
      productId.hashCode ^
      articleId.hashCode;
  }
}
