import 'package:nfc/core/layers/presentation/state/requests/request_cubit/request_cubit.dart';
import 'package:nfc/features/home/domain/entities/operation_type_enum.dart';
import 'package:nfc/features/home/domain/entities/user.dart';
import 'package:nfc/features/home/domain/usecases/make_transaction_usecase.dart';

class MakeTransactionBloc extends RequestCubit<void> {
  final MakeTransactionUsecase _makeTransactionUsecase;

  MakeTransactionBloc(this._makeTransactionUsecase);

  Future<void> makeTransaction(
    UserEntity user,
    OperationTypeEnum operationType,
    double amount,
  ) async {
    execute(
      request: () => _makeTransactionUsecase.call(user, operationType, amount),
    );
  }
}
