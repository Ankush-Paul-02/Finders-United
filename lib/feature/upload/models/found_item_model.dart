import 'dart:convert';

class FoundItemModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String date;
  final String category;
  final String imageUrl;
  final String founderId;
  final String founderName;
  final String founderContact;
  final List<String> claimableIds;
  final bool isClaimed;
  final DateTime createdAt;
  final String claimerPersonId;

  FoundItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.category,
    required this.imageUrl,
    required this.founderId,
    required this.founderName,
    required this.founderContact,
    required this.claimableIds,
    required this.isClaimed,
    required this.createdAt,
    required this.claimerPersonId,
  });

  FoundItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? date,
    String? category,
    String? imageUrl,
    String? founderId,
    String? founderName,
    String? founderContact,
    List<String>? claimableIds,
    bool? isClaimed,
    DateTime? createdAt,
    String? claimerPersonId,
  }) {
    return FoundItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      founderId: founderId ?? this.founderId,
      founderName: founderName ?? this.founderName,
      founderContact: founderContact ?? this.founderContact,
      claimableIds: claimableIds ?? this.claimableIds,
      isClaimed: isClaimed ?? this.isClaimed,
      createdAt: createdAt ?? this.createdAt,
      claimerPersonId: claimerPersonId ?? this.claimerPersonId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'date': date,
      'category': category,
      'imageUrl': imageUrl,
      'founderId': founderId,
      'founderName': founderName,
      'founderContact': founderContact,
      'claimableIds': claimableIds,
      'isClaimed': isClaimed,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'claimerPersonId': claimerPersonId,
    };
  }

  factory FoundItemModel.fromMap(Map<String, dynamic> map) {
    return FoundItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      founderId: map['founderId'] as String,
      founderName: map['founderName'] as String,
      founderContact: map['founderContact'] as String,
      claimableIds: List<String>.from((map['claimableIds'] as List<String>)),
      isClaimed: map['isClaimed'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      claimerPersonId: map['claimerPersonId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoundItemModel.fromJson(String source) =>
      FoundItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoundItemModel(id: $id, name: $name, description: $description, location: $location, date: $date, category: $category, imageUrl: $imageUrl, founderId: $founderId, founderName: $founderName, founderContact: $founderContact, claimableIds: $claimableIds, isClaimed: $isClaimed, createdAt: $createdAt, claimerPersonId: $claimerPersonId)';
  }
}
