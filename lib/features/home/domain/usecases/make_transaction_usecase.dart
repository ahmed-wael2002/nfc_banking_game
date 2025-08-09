import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class MakeTransactionUsecase {
  final UserRepositoryInterface _userRepository;

  MakeTransactionUsecase(this._userRepository);

  Future<RequestResult<void>> call(UserEntity user, OperationTypeEnum operationType, double amount) async {
    return _userRepository.makeTransaction(user, operationType, amount);
  }
}