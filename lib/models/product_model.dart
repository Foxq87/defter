// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  final String id;
  final String uid;
  final String title;
  final String schoolId;
  final double price;
  final int stock;
  final String categorie;
  final String subcategorie;
  final int approve;
  final String description;
  final List<String> images;
  final List<String> bookmarks;
  final DateTime createdAt;
  ProductModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.schoolId,
    required this.price,
    required this.stock,
    required this.categorie,
    required this.subcategorie,
    required this.approve,
    required this.description,
    required this.images,
    required this.bookmarks,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? schoolId,
    double? price,
    int? stock,
    String? categorie,
    String? subcategorie,
    int? approve,
    String? description,
    List<String>? images,
    List<String>? bookmarks,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      schoolId: schoolId ?? this.schoolId,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      categorie: categorie ?? this.categorie,
      subcategorie: subcategorie ?? this.subcategorie,
      approve: approve ?? this.approve,
      description: description ?? this.description,
      images: images ?? this.images,
      bookmarks: bookmarks ?? this.bookmarks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'schoolId': schoolId,
      'price': price,
      'stock': stock,
      'categorie': categorie,
      'subcategorie': subcategorie,
      'approve': approve,
      'description': description,
      'images': images,
      'bookmarks': bookmarks,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      title: map['title'] as String,
      schoolId: map['schoolId'] as String,
      price: map['price'] as double,
      stock: map['stock'] as int,
      categorie: map['categorie'] as String,
      subcategorie: map['subcategorie'] as String,
      approve: map['approve'] as int,
      description: map['description'] as String,
      images: List<String>.from((map['images'] as List<dynamic>)),
      bookmarks: List<String>.from((map['bookmarks'] as List<dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, uid: $uid, title: $title, schoolId: $schoolId, price: $price, stock: $stock, categorie: $categorie, subcategorie: $subcategorie, approve: $approve, description: $description, images: $images, bookmarks: $bookmarks, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.schoolId == schoolId &&
        other.price == price &&
        other.stock == stock &&
        other.categorie == categorie &&
        other.subcategorie == subcategorie &&
        other.approve == approve &&
        other.description == description &&
        listEquals(other.images, images) &&
        listEquals(other.bookmarks, bookmarks) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        schoolId.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        categorie.hashCode ^
        subcategorie.hashCode ^
        approve.hashCode ^
        description.hashCode ^
        images.hashCode ^
        bookmarks.hashCode ^
        createdAt.hashCode;
  }
}
