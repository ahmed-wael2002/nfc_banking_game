import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class FailureBase extends Error {
  final Object? exception;
  final String message;

  @override
  final StackTrace? stackTrace;

  FailureBase(
      {this.exception, this.message = "Something went wrong", this.stackTrace});

  String getDisplayMessage(BuildContext context);

  String getRunModeDependentMessage(BuildContext context) {
    final debugMessage = '''
      $message
      ${exception.toString()}
    ''';

    return kDebugMode ? debugMessage : getDisplayMessage(context);
  }
}

class Failure extends FailureBase {
  Failure({super.exception, required super.message, super.stackTrace});

  @override
  String getDisplayMessage(BuildContext context) {
    return 'An error occurred: $message';
  }
}
