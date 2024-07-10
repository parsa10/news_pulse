import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pulse/src/features/news/application/news_service.dart';
import 'package:news_pulse/src/features/news/presentation/news_card.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsyncValue = ref.watch(newsArticlesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Pulse'),
      ),
      body: articlesAsyncValue.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('No articles found.'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return NewsCard(article: article);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
