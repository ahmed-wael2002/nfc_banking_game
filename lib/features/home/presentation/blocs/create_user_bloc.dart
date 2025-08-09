import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/usecases/create_user_usecase.dart';

class CreateUserBloc extends RequestCubit<void> {
  final CreateUserUsecase _usecase;

  CreateUserBloc(this._usecase);

  Future<void> createUser(UserEntity user) async {
    execute(request: () => _usecase(user));
  }
}
