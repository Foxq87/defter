// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TestModel {
  final String testId;
  final String uid;
  final String lesson;
  final DateTime createdAt;
  final int correct;
  final int wrong;
  final int empty;
  final double net;
  TestModel({
    required this.testId,
    required this.uid,
    required this.lesson,
    required this.createdAt,
    required this.correct,
    required this.wrong,
    required this.empty,
    required this.net,
  });

  TestModel copyWith({
    String? testId,
    String? uid,
    String? lesson,
    DateTime? createdAt,
    int? correct,
    int? wrong,
    int? empty,
    double? net,
  }) {
    return TestModel(
      testId: testId ?? this.testId,
      uid: uid ?? this.uid,
      lesson: lesson ?? this.lesson,
      createdAt: createdAt ?? this.createdAt,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      empty: empty ?? this.empty,
      net: net ?? this.net,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'testId': testId,
      'uid': uid,
      'lesson': lesson,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'correct': correct,
      'wrong': wrong,
      'empty': empty,
      'net': net,
    };
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      testId: map['testId'] as String,
      uid: map['uid'] as String,
      lesson: map['lesson'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      correct: map['correct'] as int,
      wrong: map['wrong'] as int,
      empty: map['empty'] as int,
      net: map['net'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestModel.fromJson(String source) =>
      TestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestModel(testId: $testId, uid: $uid, lesson: $lesson, createdAt: $createdAt, correct: $correct, wrong: $wrong, empty: $empty, net: $net)';
  }

  @override
  bool operator ==(covariant TestModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.testId == testId &&
      other.uid == uid &&
      other.lesson == lesson &&
      other.createdAt == createdAt &&
      other.correct == correct &&
      other.wrong == wrong &&
      other.empty == empty &&
      other.net == net;
  }

  @override
  int get hashCode {
    return testId.hashCode ^
      uid.hashCode ^
      lesson.hashCode ^
      createdAt.hashCode ^
      correct.hashCode ^
      wrong.hashCode ^
      empty.hashCode ^
      net.hashCode;
  }
}
