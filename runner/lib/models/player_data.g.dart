part of 'player_data.dart';

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData()..highScore = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.highScore);
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType  == other.runtimeType &&
          typeId == other.typeId;
}