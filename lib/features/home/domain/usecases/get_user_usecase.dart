import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/core/usecases/usecase.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class GetUserUsecase implements UseCase<UserEntity, NoParams> {
  final UserRepositoryInterface _userRepository;

  GetUserUsecase(this._userRepository);

  @override
  Future<RequestResult<UserEntity>> call(NoParams params) async {
    return _userRepository.getUser();
  }
}
