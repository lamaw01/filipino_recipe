// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeHiveAdapter extends TypeAdapter<RecipeHive> {
  @override
  final int typeId = 0;

  @override
  RecipeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeHive(
      id: fields[0] as String,
      image: fields[1] as String,
      description: fields[2] as String,
      ingredients: (fields[3] as List).cast<String>(),
      instructions: (fields[4] as List).cast<String>(),
      name: fields[5] as String,
      category: fields[6] as String,
      cookTime: fields[7] as String,
      prepTime: fields[8] as String,
      url: fields[9] as String,
      timestamp: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.ingredients)
      ..writeByte(4)
      ..write(obj.instructions)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.cookTime)
      ..writeByte(8)
      ..write(obj.prepTime)
      ..writeByte(9)
      ..write(obj.url)
      ..writeByte(10)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
