import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../constants/typedefs.dart';
import '../layers/data/failure/failure.dart';

Future<RequestResult<T>> safeAwait<T>(Future<T> Function() future) async {
  try {
    final result = await future();
    return Right(result);
  } catch (error, stackTrace) {
    return Left(Failure(
      exception: error,
      message: error.toString(),
      stackTrace: stackTrace,
    ));
  }
}

Stream<RequestResult<T>> safeYieldStream<T>(
    Stream<T> Function() stream) async* {
  try {
    await for (final item in stream()) {
      debugPrint("Safe yield stream ${item.toString()}");
      yield Right(item); // Success case
    }
  } catch (error, stackTrace) {
    debugPrint("Safe yield stream error ${error.toString()}");
    yield Left(Failure(
        exception: error,
        message: error.toString(),
        stackTrace: stackTrace)); // Error case
  }
}
