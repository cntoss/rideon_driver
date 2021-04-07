// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addressType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressTypeAdapter extends TypeAdapter<AddressType> {
  @override
  final int typeId = 2;

  @override
  AddressType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AddressType.Home;
      case 1:
        return AddressType.Work;
      case 2:
        return AddressType.Other;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, AddressType obj) {
    switch (obj) {
      case AddressType.Home:
        writer.writeByte(0);
        break;
      case AddressType.Work:
        writer.writeByte(1);
        break;
      case AddressType.Other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
