// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class CardAdapter extends TypeAdapter<Card> {
  @override
  final typeId = 1;

  @override
  Card read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Card(
      name: fields[0] as String,
      location: fields[1] as String,
      creationDate: fields[2] as DateTime?,
      description: fields[3] as String,
      imageURL: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Card obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TourDeckAdapter extends TypeAdapter<TourDeck> {
  @override
  final typeId = 2;

  @override
  TourDeck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TourDeck(
      name: fields[0] as String,
      location: fields[1] as String,
      creationDate: fields[2] as DateTime?,
      cardIds: (fields[3] as List).cast<int>(),
      isMine: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TourDeck obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(3)
      ..write(obj.cardIds)
      ..writeByte(4)
      ..write(obj.isMine);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TourDeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
