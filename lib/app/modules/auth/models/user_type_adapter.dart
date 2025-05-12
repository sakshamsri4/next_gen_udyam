import 'package:hive/hive.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';

/// Adapter for UserType enum to be used with Hive
class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 20;

  @override
  UserType read(BinaryReader reader) {
    final index = reader.readByte();
    return UserType.values[index];
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    writer.writeByte(obj.index);
  }
}
