import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:news_pulse/src/core/utils/extensions/json_decode.dart';

mixin RequestProcessor {
  @protected
  TaskEither<AppException, Response> makeRequest(
    Future<Response> Function() request,
  ) =>
      TaskEither.tryCatch(
        request,
        (error, stackTrace) =>
            HttpException(error: error, stackTrace: stackTrace),
      );

  /// for json object responses
  @protected
  Either<AppException, P> processResponse<P, D>({
    required Response response,
    required D Function(Map<String, dynamic>) dataToDto,
    required Either<AppException, P> Function(D) processDto,
    bool Function(int code)? validStatusCode,
  }) =>
      Either.Do(($) {
        final body = $(
          validResponseBody(
            response,
          ),
        );

        final data = $(
          body.jsonDecodeEither(),
        );

        final dto = $(
          Either.tryCatch(
            () => dataToDto(data),
            (error, stackTrace) => JsonToDtoException(
              error: error,
              stackTrace: stackTrace,
            ),
          ),
        );

        return $(processDto(dto));
      });

  @protected
  Either<AppException, String> validResponseBody(
    Response response, {
    bool Function(int code)? validStatusCode,
  }) =>
      Either<AppException, Response>.fromPredicate(
        response,
        (r) =>
            validStatusCode?.call(r.statusCode) ??
            r.statusCode < HttpStatus.badRequest,
        (r) => RequestException(
          statusCode: r.statusCode,
          reason: r.reasonPhrase,
          body: r.body,
        ),
      ).map((r) => r.body);
}
