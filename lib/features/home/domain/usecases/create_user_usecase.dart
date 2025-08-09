import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/core/usecases/usecase.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class CreateUserUsecase implements UseCase<void, UserEntity> {
  final UserRepositoryInterface _userRepository;

  CreateUserUsecase(this._userRepository);

  @override
  Future<RequestResult<void>> call(UserEntity params) async {
    return _userRepository.createUser(params);
  }
}
