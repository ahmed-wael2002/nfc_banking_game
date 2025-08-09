import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/core/usecases/usecase.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/usecases/get_user_usecase.dart';

class GetUserBloc extends RequestCubit<UserEntity> {
  final GetUserUsecase _usecase;

  GetUserBloc(this._usecase);

  Future<void> getUser() async {
    execute(request: () => _usecase(NoParams()));
  }
}
