import 'package:nfc/core/constants/typedefs.dart';

abstract class UseCase<Type, Params> {
  Future<RequestResult<Type>> call(Params params);
}

class NoParams {}
