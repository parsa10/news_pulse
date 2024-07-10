import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pulse/src/core/errors/error_logger.dart';

class ErrorObserver extends ProviderObserver {
  ErrorObserver();

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    container.read(errorLoggerProvider).logError(error, stackTrace);
  }
}
