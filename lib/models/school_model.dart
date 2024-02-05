// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class School {
  final String id;
  final String title;
  final String banner;
  final String avatar;
  final List<String> students;
  final List<String> mods;
  School({
    required this.id,
    required this.title,
    required this.banner,
    required this.avatar,
    required this.students,
    required this.mods,
  });

  School copyWith({
    String? id,
    String? title,
    String? banner,
    String? avatar,
    List<String>? students,
    List<String>? mods,
  }) {
    return School(
      id: id ?? this.id,
      title: title ?? this.title,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      students: students ?? this.students,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'banner': banner,
      'avatar': avatar,
      'students': students,
      'mods': mods,
    };
  }

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'] as String,
      title: map['title'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      students: List<String>.from(map['students']),
      mods: List<String>.from((map['mods'])),
    );
  }

  @override
  String toString() {
    return 'School(id: $id, title: $title, banner: $banner, avatar: $avatar, students: $students, mods: $mods)';
  }

  @override
  bool operator ==(covariant School other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.students, students) &&
        listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        students.hashCode ^
        mods.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory School.fromJson(String source) =>
      School.fromMap(json.decode(source) as Map<String, dynamic>);
}
