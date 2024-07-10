import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:news_pulse/src/core/utils/mixins/deps.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';

mixin LocalNewsRepoDep on RefDep {
  @protected
  LocalNewsRepo get localNewsRepo => ref.read(localNewsRepoProvider);
}

final localNewsRepoProvider = Provider.autoDispose(LocalNewsRepo.new);

class LocalNewsRepo with RefDep, DatabaseDep {
  LocalNewsRepo(this.ref);

  @override
  final Ref ref;

  TaskEither<AppException, List<NewsArticle>> getCachedArticles() =>
      TaskEither.tryCatch(
        () => database.newsArticles.filter().contentIsNotEmpty().findAll(),
        (error, stackTrace) =>
            DatabaseException(error: error, stackTrace: stackTrace),
      );

  TaskEither<AppException, void> cacheArticles(
    List<NewsArticle> articles,
  ) =>
      getCachedArticles().flatMap(
        (cached) => TaskEither.tryCatch(
          () => database.writeTxn(
            () => database.newsArticles
                // to prevent duplicates
                .putAll(<NewsArticle>{...cached, ...articles}.toList()),
          ),
          (error, stackTrace) =>
              DatabaseException(error: error, stackTrace: stackTrace),
        ),
      );
}
