import 'package:fpdart/fpdart.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';

extension RunOrThrow<R> on TaskEither<AppException, R> {
  Future<R> runOrThrow() => getOrElse((l) => throw l).run();
}
