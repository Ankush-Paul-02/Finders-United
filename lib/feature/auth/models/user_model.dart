import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final List<String> bookmarkItems;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.bookmarkItems,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'bookmarkItems': bookmarkItems,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      imageUrl: map['imageUrl'] as String,
      // Use null-aware operator to handle null case and default to empty list
      bookmarkItems: (map['bookmarkItems'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? imageUrl,
    List<String>? bookmarkItems,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      bookmarkItems: bookmarkItems ?? this.bookmarkItems,
    );
  }
}
