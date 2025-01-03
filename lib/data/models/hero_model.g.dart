// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IslamicHeroAdapter extends TypeAdapter<IslamicHero> {
  @override
  final int typeId = 0;

  @override
  IslamicHero read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IslamicHero(
      id: fields[0] as String,
      name: fields[1] as String,
      era: fields[2] as String,
      achievements: (fields[3] as List).cast<String>(),
      biography: fields[4] as String,
      imageUrl: fields[5] as String?,
      birthDate: fields[6] as String?,
      deathDate: fields[7] as String?,
      birthPlace: fields[8] as String?,
      contributions: (fields[9] as List?)?.cast<String>(),
      famousQuotes: (fields[10] as List?)?.cast<String>(),
      historicalEvents: (fields[11] as List?)?.cast<String>(),
      familyRelations: (fields[12] as Map?)?.cast<String, String>(),
      books: (fields[13] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, IslamicHero obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.era)
      ..writeByte(3)
      ..write(obj.achievements)
      ..writeByte(4)
      ..write(obj.biography)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.birthDate)
      ..writeByte(7)
      ..write(obj.deathDate)
      ..writeByte(8)
      ..write(obj.birthPlace)
      ..writeByte(9)
      ..write(obj.contributions)
      ..writeByte(10)
      ..write(obj.famousQuotes)
      ..writeByte(11)
      ..write(obj.historicalEvents)
      ..writeByte(12)
      ..write(obj.familyRelations)
      ..writeByte(13)
      ..write(obj.books);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IslamicHeroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
