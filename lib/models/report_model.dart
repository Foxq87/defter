// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Report {
  final String id;

  final String reportingUid;
  final String noteId;
  final String reportedUid;
  final String reason;
  final String detail;
  final bool? isEvaluated;
  final DateTime createdAt;
  Report({
    required this.id,
    required this.reportingUid,
    required this.noteId,
    required this.reportedUid,
    required this.reason,
    required this.detail,
    required this.isEvaluated,
    required this.createdAt,
  });

  Report copyWith({
    String? id,
    String? reportingUid,
    String? noteId,
    String? reportedUid,
    String? reason,
    String? detail,
    bool? isEvaluated,
    DateTime? createdAt,
  }) {
    return Report(
      id: id ?? this.id,
      reportingUid: reportingUid ?? this.reportingUid,
      noteId: noteId ?? this.noteId,
      reportedUid: reportedUid ?? this.reportedUid,
      reason: reason ?? this.reason,
      detail: detail ?? this.detail,
      isEvaluated: isEvaluated ?? this.isEvaluated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reportingUid': reportingUid,
      'noteId': noteId,
      'reportedUid': reportedUid,
      'reason': reason,
      'detail': detail,
      'isEvaluated': isEvaluated,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      reportingUid: map['reportingUid'] as String,
      noteId: map['noteId'] as String,
      reportedUid: map['reportedUid'] as String,
      reason: map['reason'] as String,
      detail: map['detail'] as String,
      isEvaluated:
          map['isEvaluated'] != null ? map['isEvaluated'] as bool : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(id: $id, reportingUid: $reportingUid, noteId: $noteId, reportedUid: $reportedUid, reason: $reason, detail: $detail, isEvaluated: $isEvaluated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.reportingUid == reportingUid &&
        other.noteId == noteId &&
        other.reportedUid == reportedUid &&
        other.reason == reason &&
        other.detail == detail &&
        other.isEvaluated == isEvaluated &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reportingUid.hashCode ^
        noteId.hashCode ^
        reportedUid.hashCode ^
        reason.hashCode ^
        detail.hashCode ^
        isEvaluated.hashCode ^
        createdAt.hashCode;
  }
}
