import 'package:nfc/features/home/data/models/user.dart';
import 'package:nfc/features/home/domain/entities/user.dart';

class UserEntityModelMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(id: model.id, name: model.name, balance: model.balance);
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(id: entity.id, name: entity.name, balance: entity.balance);
  }
}
