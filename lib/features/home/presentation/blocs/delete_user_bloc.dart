import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/features/home/domain/usecases/delete_user_usecase.dart';

class DeleteUserBloc extends RequestCubit<void> {
  final DeleteUserUsecase _usecase;

  DeleteUserBloc(this._usecase);

  Future<void> deleteUser(String id) async {
    execute(request: () => _usecase(id));
  }
}
