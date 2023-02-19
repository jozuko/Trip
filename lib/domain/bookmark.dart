import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:trip/util/json_model.dart';

///
/// Created by jozuko on 2023/02/18.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Bookmark extends Equatable {
  final String url;
  final String title;
  final String description;
  final String imageUrl;

  const Bookmark({
    required this.url,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Bookmark.fromJsonMap(Map<String, dynamic> jsonMap) {
    return Bookmark(
      url: JsonModel.stringValue(jsonMap['url']),
      title: JsonModel.stringValue(jsonMap['title']),
      description: JsonModel.stringValue(jsonMap['description']),
      imageUrl: JsonModel.stringValue(jsonMap['imageUrl']),
    );
  }

  factory Bookmark.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = const JsonDecoder().convert(jsonString);
    return Bookmark.fromJsonMap(jsonMap);
  }

  Bookmark copyWith({
    String? url,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return Bookmark(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> get jsonMap {
    return {
      'url': url,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  String get jsonString {
    return jsonEncode(jsonMap);
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
