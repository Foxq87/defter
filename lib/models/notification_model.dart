// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String id;
  final String type;
  final String senderUid;
  final String receiverUid;
  final String content;
  final String? postId;
  final String? productId;
  final String? articleId;
  final DateTime createdAt;
  NotificationModel({
    required this.id,
    required this.type,
    required this.senderUid,
    required this.receiverUid,
    required this.content,
    this.postId,
    this.productId,
    this.articleId,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? type,
    String? senderUid,
    String? receiverUid,
    String? content,
    String? postId,
    String? productId,
    String? articleId,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      senderUid: senderUid ?? this.senderUid,
      receiverUid: receiverUid ?? this.receiverUid,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      productId: productId ?? this.productId,
      articleId: articleId ?? this.articleId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'content': content,
      'postId': postId,
      'productId': productId,
      'articleId': articleId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      type: map['type'] as String,
      senderUid: map['senderUid'] as String,
      receiverUid: map['receiverUid'] as String,
      content: map['content'] as String,
      postId: map['postId'] != null ? map['postId'] as String : null,
      productId: map['productId'] != null ? map['productId'] as String : null,
      articleId: map['articleId'] != null ? map['articleId'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, type: $type, senderUid: $senderUid, receiverUid: $receiverUid, content: $content, postId: $postId, productId: $productId, articleId: $articleId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.type == type &&
      other.senderUid == senderUid &&
      other.receiverUid == receiverUid &&
      other.content == content &&
      other.postId == postId &&
      other.productId == productId &&
      other.articleId == articleId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      senderUid.hashCode ^
      receiverUid.hashCode ^
      content.hashCode ^
      postId.hashCode ^
      productId.hashCode ^
      articleId.hashCode ^
      createdAt.hashCode;
  }
}
