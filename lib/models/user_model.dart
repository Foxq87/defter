import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String uid;
  final String username;
  final String name;
  final String profilePic;
  final String schoolId;
  final String email;
  final String banner;
  final String bio;

  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.profilePic,
    required this.schoolId,
    required this.email,
    required this.banner,
    required this.bio,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? name,
    String? profilePic,
    String? schoolId,
    String? email,
    String? banner,
    String? bio,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      schoolId: schoolId ?? this.schoolId,
      email: email ?? this.email,
      banner: banner ?? this.banner,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'name': name,
      'profilePic': profilePic,
      'schoolId': schoolId,
      'email': email,
      'banner': banner,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      schoolId: map['schoolId'] as String,
      email: map['email'] as String,
      banner: map['banner'] as String,
      bio: map['bio'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, name: $name, profilePic: $profilePic, schoolId: $schoolId, email: $email, banner: $banner, bio: $bio)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.username == username &&
      other.name == name &&
      other.profilePic == profilePic &&
      other.schoolId == schoolId &&
      other.email == email &&
      other.banner == banner &&
      other.bio == bio;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      username.hashCode ^
      name.hashCode ^
      profilePic.hashCode ^
      schoolId.hashCode ^
      email.hashCode ^
      banner.hashCode ^
      bio.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
