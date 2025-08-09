import 'package:dartz/dartz.dart';

import '../layers/data/failure/failure.dart';

typedef Json = Map<String, dynamic>;
typedef RequestResult<T> = Either<FailureBase, T>;
