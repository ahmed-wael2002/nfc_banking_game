import 'package:get_it/get_it.dart';
import 'package:nfc/features/home/data/data_source/data_source_interface.dart';
import 'package:nfc/features/home/data/data_source/remote/nfc_data_source_impl.dart';
import 'package:nfc/features/home/data/repository/user_repository_impl.dart';
import 'package:nfc/features/home/domain/repository/user_repository_interface.dart';
import 'package:nfc/features/home/domain/usecases/create_user_usecase.dart';
import 'package:nfc/features/home/domain/usecases/delete_user_usecase.dart';
import 'package:nfc/features/home/domain/usecases/get_user_usecase.dart';
import 'package:nfc/features/home/domain/usecases/make_transaction_usecase.dart';
import 'package:nfc/features/home/domain/usecases/update_user_usecase.dart';
import 'package:nfc/features/home/presentation/blocs/create_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/delete_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/get_user_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/make_transaction_bloc.dart';
import 'package:nfc/features/home/presentation/blocs/update_user_bloc.dart';

final _getIt = GetIt.instance;

T getService<T extends Object>({String? instanceName}) =>
    _getIt<T>(instanceName: instanceName);

void setUpServices() {
  _setUpRepositories();
  _setUpUseCases();
  _setUpBlocs();
}

void _setUpRepositories() {
  /*
  User Repository
  */
  // Data Source
  _getIt.registerSingleton<UserDataSourceInterface>(NfcDataSourceImpl());
  // Repository
  _getIt.registerSingleton<UserRepositoryInterface>(
    UserRepositoryImpl(_getIt.get<UserDataSourceInterface>()),
  );
}

void _setUpUseCases() {
  /*
  User Use Cases
  */
  // Get User
  _getIt.registerSingleton<GetUserUsecase>(
    GetUserUsecase(_getIt.get<UserRepositoryInterface>()),
  );
  // Update User
  _getIt.registerSingleton<UpdateUserUsecase>(
    UpdateUserUsecase(_getIt.get<UserRepositoryInterface>()),
  );
  // Delete User
  _getIt.registerSingleton<DeleteUserUsecase>(
    DeleteUserUsecase(_getIt.get<UserRepositoryInterface>()),
  );
  // Create User
  _getIt.registerSingleton<CreateUserUsecase>(
    CreateUserUsecase(_getIt.get<UserRepositoryInterface>()),
  );
  // Make Transaction
  _getIt.registerSingleton<MakeTransactionUsecase>(
    MakeTransactionUsecase(_getIt.get<UserRepositoryInterface>()),
  );
}

void _setUpBlocs() {
  /*
  User Bloc
  */
  // Register BLoCs as factories to ensure a fresh instance per request/context
  // Get User
  _getIt.registerFactory<GetUserBloc>(
    () => GetUserBloc(_getIt.get<GetUserUsecase>()),
  );
  // Update User
  _getIt.registerFactory<UpdateUserBloc>(
    () => UpdateUserBloc(_getIt.get<UpdateUserUsecase>()),
  );
  // Delete User
  _getIt.registerFactory<DeleteUserBloc>(
    () => DeleteUserBloc(_getIt.get<DeleteUserUsecase>()),
  );
  // Create User
  _getIt.registerFactory<CreateUserBloc>(
    () => CreateUserBloc(_getIt.get<CreateUserUsecase>()),
  );
  // Make Transaction
  _getIt.registerFactory<MakeTransactionBloc>(
    () => MakeTransactionBloc(_getIt.get<MakeTransactionUsecase>()),
  );
}
