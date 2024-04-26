// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Report {
  final String uid;
  final String noteId;
  final String accountId;
  final String reason;
  final String detail;
  final DateTime createdAt;

  Report({
    required this.uid,
    required this.noteId,
    required this.accountId,
    required this.reason,
    required this.detail,
    required this.createdAt,
  });

  Report copyWith({
    String? uid,
    String? noteId,
    String? accountId,
    String? reason,
    String? detail,
    DateTime? createdAt,
  }) {
    return Report(
      uid: uid ?? this.uid,
      noteId: noteId ?? this.noteId,
      accountId: accountId ?? this.accountId,
      reason: reason ?? this.reason,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'noteId': noteId,
      'accountId': accountId,
      'reason': reason,
      'detail': detail,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      uid: map['uid'] as String,
      noteId: map['noteId'] as String,
      accountId: map['accountId'] as String,
      reason: map['reason'] as String,
      detail: map['detail'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(uid: $uid, noteId: $noteId, accountId: $accountId, reason: $reason, detail: $detail, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.noteId == noteId &&
        other.accountId == accountId &&
        other.reason == reason &&
        other.detail == detail &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        noteId.hashCode ^
        accountId.hashCode ^
        reason.hashCode ^
        detail.hashCode ^
        createdAt.hashCode;
  }
}
