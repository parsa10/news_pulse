import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:news_pulse/src/core/utils/extensions/fast_hash.dart';
import 'package:news_pulse/src/features/news/domain/news_dto/news_dto.dart';

part 'news_article.g.dart';

@Collection(inheritance: false)
class NewsArticle extends Equatable {
  const NewsArticle({
    required this.url,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.source,
    required this.imageUrl,
    required this.publishedAt,
    required this.category,
  });

  factory NewsArticle.fromDto({
    required ArticleDto dto,
    required String category,
  }) =>
      NewsArticle(
        url: dto.url ?? '',
        title: dto.title ?? 'Unknown Title',
        description: dto.description ?? '',
        content: dto.content ?? 'Unknown Content',
        author: dto.author ?? 'Unknown',
        source: dto.source.name ?? 'Unknown Source',
        imageUrl:
            dto.urlToImage ?? 'https://placehold.co/600x400?text=Hello+World',
        publishedAt: dto.publishedAt ?? DateTime.now(),
        category: category,
      );

  final String url;
  final String title;
  final String description;
  final String content;
  final String author;
  final String source;
  final String imageUrl;
  final DateTime publishedAt;
  final String category;

  Id get isarId => url.fastHash;

  @ignore
  @override
  List<Object?> get props => [
        url,
        title,
        description,
        content,
        author,
        source,
        imageUrl,
        publishedAt,
        category,
      ];
}
