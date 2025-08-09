import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/core/utils/safe_await.dart';
import 'package:nfc/features/home/data/data_source/data_source_interface.dart';
import 'package:nfc/features/home/data/mapper/user.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class UserRepositoryImpl implements UserRepositoryInterface {
  final UserDataSourceInterface _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<RequestResult<void>> createUser(UserEntity user) async {
    return safeAwait(
      () => _dataSource.createUser(UserEntityModelMapper.toModel(user)),
    );
  }

  @override
  Future<RequestResult<void>> deleteUser(String id) async {
    return safeAwait(() => _dataSource.deleteUser(id));
  }

  @override
  Future<RequestResult<UserEntity>> getUser() async {
    return safeAwait(() => _dataSource.getUser());
  }

  @override
  Future<RequestResult<void>> updateUser(UserEntity user) async {
    return safeAwait(
      () => _dataSource.updateUser(UserEntityModelMapper.toModel(user)),
    );
  }

  @override
  Future<RequestResult<void>> makeTransaction(
    UserEntity user,
    OperationTypeEnum operationType,
    double amount,
  ) async {
    return safeAwait(
      () => _dataSource.makeTransaction(
        UserEntityModelMapper.toModel(user),
        operationType,
        amount,
      ),
    );
  }
}
