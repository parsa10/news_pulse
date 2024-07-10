import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_dto.freezed.dart';
part 'news_dto.g.dart';

@freezed
class NewsDto with _$NewsDto {
  const factory NewsDto({
    required String? status,
    required int? totalResults,
    required List<ArticleDto> articles,
  }) = _NewsDto;

  factory NewsDto.fromJson(Map<String, dynamic> json) =>
      _$NewsDtoFromJson(json);
}

@freezed
class ArticleDto with _$ArticleDto {
  const factory ArticleDto({
    required SourceDto source,
    required String? author,
    required String? title,
    required String? description,
    required String? url,
    required String? urlToImage,
    required DateTime? publishedAt,
    required String? content,
  }) = _ArticleDto;

  factory ArticleDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDtoFromJson(json);
}

@freezed
class SourceDto with _$SourceDto {
  const factory SourceDto({
    required String? id,
    required String? name,
  }) = _SourceDto;

  factory SourceDto.fromJson(Map<String, dynamic> json) =>
      _$SourceDtoFromJson(json);
}
