import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/usecases/update_user_usecase.dart';

class UpdateUserBloc extends RequestCubit<void> {
  final UpdateUserUsecase _usecase;

  UpdateUserBloc(this._usecase);

  Future<void> updateUser(UserEntity user) async {
    execute(request: () => _usecase(user));
  }
}