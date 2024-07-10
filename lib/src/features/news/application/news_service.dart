import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:news_pulse/src/core/utils/extensions/fp_run_or_throw.dart';
import 'package:news_pulse/src/core/utils/mixins/deps.dart';
import 'package:news_pulse/src/features/news/data/connectivity_repo.dart';
import 'package:news_pulse/src/features/news/data/local_news_repo.dart';
import 'package:news_pulse/src/features/news/data/news_repo.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';

final newsServiceProvider = Provider.autoDispose<NewsService>(NewsService.new);

class NewsService
    with RefDep, ConnectivityRepoDep, NewsRepoDep, LocalNewsRepoDep {
  NewsService(this.ref);

  @override
  final Ref ref;

  TaskEither<AppException, List<NewsArticle>> getArticles() =>
      TaskEither<AppException, List<NewsArticle>>.Do(($) async {
        final isConnected = await $(connectivityRepo.isConnected());

        if (!isConnected) {
          return $(localNewsRepo.getCachedArticles());
        }

        final articles = await $(newsRepo.getArticles());

        await $(
          localNewsRepo.cacheArticles(articles),
        );

        return articles;
      });
}

final newsArticlesProvider =
    FutureProvider.autoDispose<List<NewsArticle>>((ref) {
  return ref.watch(newsServiceProvider).getArticles().runOrThrow();
});
