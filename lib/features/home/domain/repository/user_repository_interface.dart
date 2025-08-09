import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';
import 'package:nfc/features/home/domain/entities/user.dart';

abstract class UserRepositoryInterface {
  Future<RequestResult<UserEntity>> getUser();
  Future<RequestResult<void>> updateUser(UserEntity user);
  Future<RequestResult<void>> deleteUser(String id);
  Future<RequestResult<void>> createUser(UserEntity user);
  Future<RequestResult<void>> makeTransaction(
    UserEntity user,
    OperationTypeEnum operationType,
    double amount,
  );
}
