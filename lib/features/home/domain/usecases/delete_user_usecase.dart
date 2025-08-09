import 'package:nfc/core/constants/typedefs.dart';
import 'package:nfc/core/usecases/usecase.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';

class DeleteUserUsecase implements UseCase<void, String> {
  final UserRepositoryInterface _userRepository;

  DeleteUserUsecase(this._userRepository);

  @override
  Future<RequestResult<void>> call(String params) async {
    return _userRepository.deleteUser(params);
  }
}