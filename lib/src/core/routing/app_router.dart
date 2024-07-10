import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_pulse/src/core/errors/error_logger.dart';
import 'package:news_pulse/src/features/news/domain/news_article/news_article.dart';
import 'package:news_pulse/src/features/news/presentation/news_detail_screen.dart';
import 'package:news_pulse/src/features/news/presentation/news_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    onException: (context, state, router) => ref
        .read(errorLoggerProvider)
        .logError(state.error!, StackTrace.current),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const NewsListScreen(),
      ),
      GoRoute(
        path: '/newsDetail',
        builder: (context, state) {
          final article = state.extra! as NewsArticle;
          return NewsDetailScreen(article: article);
        },
      ),
    ],
  );
});
