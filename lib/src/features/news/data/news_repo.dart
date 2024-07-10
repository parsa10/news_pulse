import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_pulse/src/core/errors/app_exceptions.dart';
import 'package:news_pulse/src/core/utils/mixins/deps.dart';
import 'package:news_pulse/src/core/utils/mixins/request_processor.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';
import 'package:news_pulse/src/features/news/domain/news_dto/news_dto.dart';

mixin NewsRepoDep on RefDep {
  @protected
  NewsRepo get newsRepo => ref.read(newsRepoProvider);
}

final newsRepoProvider = Provider.autoDispose(NewsRepo.new);

class NewsRepo with RefDep, EnvDep, HttpClientDep, RequestProcessor {
  NewsRepo(this.ref);

  @override
  final Ref ref;

  TaskEither<AppException, List<NewsArticle>> getArticles() =>
      TaskEither.sequenceList([
        _getArticlesByCategory('Microsoft'),
        _getArticlesByCategory('Apple'),
        _getArticlesByCategory('Google'),
        _getArticlesByCategory('Tesla'),
      ]).map((list) => list.expand((e) => e).toList());

  TaskEither<AppException, List<NewsArticle>> _getArticlesByCategory(
    String category,
  ) =>
      makeRequest(
        () => http.get(
          Uri.https(
            'newsapi.org',
            '/v2/everything',
            {
              'q': category,
              'apiKey': env.apiKey,
              'sortBy': 'publishedAt',
              // TODO: change this to 1
              'from': DateTime.now()
                  .subtract(const Duration(days: 10))
                  .toIso8601String(),
            },
          ),
        ),
      ).chainEither(
        (r) => processResponse(
          response: r,
          dataToDto: NewsDto.fromJson,
          processDto: (dto) => Either.right(
            dto.articles
                .map((a) => NewsArticle.fromDto(dto: a, category: category))
                .toList(),
          ),
        ),
      );
}
