import 'package:hive_ce/hive.dart';

class TourDeck extends HiveObject {
  String name;
  String location;
  DateTime creationDate;
  List<int> cardIds;
  bool isMine;
  bool isPlaceholder;

  TourDeck({
    required this.name,
    required this.location,
    DateTime? creationDate,
    required this.cardIds,
    required this.isMine,
    this.isPlaceholder = false,
  }) : this.creationDate = creationDate ?? DateTime.now().toUtc();

  factory TourDeck.createPlaceholder() => TourDeck(
    name: "name",
    location: "location",
    cardIds: [],
    isMine: true,
    isPlaceholder: true,
  );

  factory TourDeck.fromJson(Map<String, dynamic> json) => TourDeck(
    name: json['name'],
    location: json['location'],
    creationDate: json['creationDate'],
    isMine: json['isMine'],
    isPlaceholder: json['isMine'],
    cardIds: [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'creationDate': creationDate,
    'isMine': isMine,
    'isPlaceholder': isPlaceholder,
  };
}
