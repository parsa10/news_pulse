import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';

extension JsonDecodeAndCast on String {
  Either<AppException, Map<String, dynamic>> jsonDecodeEither({
    AppException Function(Object)? decodeError,
    AppException Function(dynamic)? castError,
  }) =>
      Either.Do(($) {
        final decoded = $(
          Either.tryCatch(
            () => jsonDecode(this),
            (o, s) =>
                decodeError?.call(o) ??
                JsonDecodeException(
                  error: o,
                  body: this,
                ),
          ),
        );

        return $(
          Either<AppException, Map<String, dynamic>>.safeCast(
            decoded,
            (value) =>
                castError?.call(decoded) ??
                InvalidMapException(
                  decodedJson: value,
                ),
          ),
        );
      });
}
