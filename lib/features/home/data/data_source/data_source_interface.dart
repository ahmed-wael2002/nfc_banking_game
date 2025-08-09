import 'package:nfc/features/home/data/models/user.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';

abstract class UserDataSourceInterface {
  Future<UserModel> getUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<void> createUser(UserModel user);
  Future<void> makeTransaction(UserModel user, OperationTypeEnum operationType, double amount);
}
