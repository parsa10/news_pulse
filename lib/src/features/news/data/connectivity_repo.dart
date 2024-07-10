import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:news_pulse/src/core/utils/mixins/deps.dart';

mixin ConnectivityRepoDep on RefDep {
  @protected
  ConnectivityRepo get connectivityRepo => ref.read(connectivityRepoProvider);
}

final connectivityRepoProvider = Provider.autoDispose(ConnectivityRepo.new);

class ConnectivityRepo with RefDep {
  ConnectivityRepo(this.ref);

  @override
  final Ref ref;

  TaskEither<AppException, bool> isConnected() => TaskEither.tryCatch(
        () => InternetConnection().hasInternetAccess,
        (error, stackTrace) =>
            ConnectivityCheckException(error: error, stackTrace: stackTrace),
      );
}
