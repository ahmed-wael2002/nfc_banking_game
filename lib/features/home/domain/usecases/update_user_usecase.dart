import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/core/usecases/usecase.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class UpdateUserUsecase implements UseCase<void, UserEntity> {
  final UserRepositoryInterface _userRepository;

  UpdateUserUsecase(this._userRepository);

  @override
  Future<RequestResult<void>> call(UserEntity params) async {
    return _userRepository.updateUser(params);
  }
}