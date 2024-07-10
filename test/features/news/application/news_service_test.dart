import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_pulse/src/core/utils/extensions/fp_run_or_throw.dart';
import 'package:news_pulse/src/features/news/application/news_service.dart';
import 'package:news_pulse/src/features/news/data/connectivity_repo.dart';
import 'package:news_pulse/src/features/news/data/local_news_repo.dart';
import 'package:news_pulse/src/features/news/data/news_repo.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('NewsService', () {
    late NewsRepo newsRepo;
    late ConnectivityRepo connectivityRepo;
    late LocalNewsRepo localNewsRepo;
    late NewsService newsService;

    final localArticles = [
      NewsArticle(
        url: 'localUrl1',
        title: 'localTitle1',
        description: 'localDescription1',
        content: 'localContent1',
        author: 'localAuthor1',
        source: 'localSource1',
        imageUrl: 'localImageUrl1',
        publishedAt: DateTime.now(),
        category: 'localCategory1',
      ),
      NewsArticle(
        url: 'localUrl2',
        title: 'localTitle2',
        description: 'localDescription2',
        content: 'localContent2',
        author: 'localAuthor2',
        source: 'localSource2',
        imageUrl: 'localImageUrl2',
        publishedAt: DateTime.now(),
        category: 'localCategory2',
      ),
    ];

    final remoteArticles = [
      NewsArticle(
        url: 'remoteUrl1',
        title: 'remoteTitle1',
        description: 'remoteDescription1',
        content: 'remoteContent1',
        author: 'remoteAuthor1',
        source: 'remoteSource1',
        imageUrl: 'remoteImageUrl1',
        publishedAt: DateTime.now(),
        category: 'remoteCategory1',
      ),
      NewsArticle(
        url: 'remoteUrl2',
        title: 'remoteTitle2',
        description: 'remoteDescription2',
        content: 'remoteContent2',
        author: 'remoteAuthor2',
        source: 'remoteSource2',
        imageUrl: 'remoteImageUrl2',
        publishedAt: DateTime.now(),
        category: 'remoteCategory2',
      ),
    ];

    NewsService makeService() {
      newsRepo = MockNewsRepo();
      localNewsRepo = MockLocalNewsRepo();
      connectivityRepo = MockConnectivityRepo();
      final container = ProviderContainer(
        overrides: [
          newsRepoProvider.overrideWithValue(newsRepo),
          localNewsRepoProvider.overrideWithValue(localNewsRepo),
          connectivityRepoProvider.overrideWithValue(connectivityRepo),
        ],
      );

      addTearDown(container.dispose);
      return container.read(newsServiceProvider);
    }

    setUp(() {
      newsService = makeService();

      when(() => newsRepo.getArticles()).thenReturn(
        TaskEither.right(remoteArticles),
      );

      when(() => localNewsRepo.getCachedArticles())
          .thenReturn(TaskEither.right(localArticles));

      when(() => localNewsRepo.cacheArticles(any()))
          .thenReturn(TaskEither.right(null));
    });

    test(
        'fetches from remote when there is internet connection and caches the results',
        () async {
      when(connectivityRepo.isConnected).thenReturn(TaskEither.right(true));

      final articles = await newsService.getArticles().runOrThrow();

      expect(articles, remoteArticles);

      // caches the results
      verify(() => localNewsRepo.cacheArticles(articles)).called(1);
      verifyNoMoreInteractions(localNewsRepo);
    });

    test('gets articles from database when there is no internet', () async {
      when(connectivityRepo.isConnected).thenReturn(TaskEither.right(false));

      final articles = await newsService.getArticles().runOrThrow();

      expect(articles, localArticles);

      // caches the results
      verifyNoMoreInteractions(newsRepo);
    });
  });
}
