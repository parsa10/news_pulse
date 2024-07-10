import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:stack_trace/stack_trace.dart';

final errorLoggerProvider = Provider.autoDispose((_) => ErrorLogger());

class ErrorLogger {
  ErrorLogger();

  Future<void> logError(Object error, StackTrace? stackTrace) async {
    if (error is AppException) {
      await logAppException(error);
    } else {
      debugPrint('$error, $stackTrace');
    }
  }

  Future<void> logAppException(AppException exception) async {
    log(
      '''
       ------------------------------------------------------------------------
       type: ${exception.runtimeType}:
       error: ${exception.error}
       additional data: ${exception.additionalData}
       stackTrace: ${customStackTrace(exception.stackTrace ?? exception.defaultStackTrace)}
       ------------------------------------------------------------------------
      ''',
    );
  }

  String customStackTrace(StackTrace stackTrace) {
    return Trace.from(stackTrace).terse.toString().split('\n').where((frame) {
      return !frame.contains('package:flutter') &&
          !frame.contains('<asynchronous suspension>');
    }).join('\n');
  }
}
