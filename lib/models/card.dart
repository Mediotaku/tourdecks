import 'package:hive_ce_flutter/hive_flutter.dart';

class Card extends HiveObject {
  String name;
  String location;
  DateTime creationDate;
  String description;
  String imageURL;

  Card({
    required this.name,
    required this.location,
    DateTime? creationDate,
    required this.description,
    required this.imageURL,
  }) : this.creationDate = creationDate ?? DateTime.now().toUtc();

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    name: json['name'],
    location: json['location'],
    creationDate: json['creationDate'],
    description: json['description'],
    imageURL: json['imageURL'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'creationDate': creationDate,
    'description': description,
    'imageURL': imageURL,
  };
}
