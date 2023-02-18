import 'package:equatable/equatable.dart';

///
/// Created by jozuko on 2023/02/18.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class AnalyzedUrl extends Equatable {
  final String url;
  final String title;
  final String description;
  final String imageUrl;

  const AnalyzedUrl({
    required this.url,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  AnalyzedUrl copyWith({
    String? url,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return AnalyzedUrl(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'url: $url,'
        'title: $title,'
        'description: $description,'
        'imageUrl: $imageUrl';
  }

  @override
  List<Object?> get props => [
        url,
        title,
        description,
        imageUrl,
      ];
}
