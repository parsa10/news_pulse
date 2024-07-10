import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:news_pulse/src/core/database/database.dart';
import 'package:news_pulse/src/core/errors/error_logger.dart';
import 'package:news_pulse/src/core/errors/error_observer.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap({
  required FutureOr<Widget> Function() builder,
  List<Override> flavorOverrides = const [],
}) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final path = (await getApplicationDocumentsDirectory()).path;
      final isar = await Isar.open(
        [
          NewsArticleSchema,
        ],
        directory: path,
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(isar),

          /// flavor overrides are prioritized
          ...flavorOverrides,
        ],
        observers: [
          ErrorObserver(),
        ],
      );

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        container
            .read(errorLoggerProvider)
            .logError(details.exception, details.stack);
      };

      final app = await builder();

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: app,
        ),
      );
    },
    (error, stackTrace) => ErrorLogger().logError(error, stackTrace),
  );
}
