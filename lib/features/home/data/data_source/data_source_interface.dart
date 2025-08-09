import 'package:nfc/features/home/data/models/user.dart';

abstract class UserDataSourceInterface {
  Future<UserModel> getUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<void> createUser(UserModel user);
}
