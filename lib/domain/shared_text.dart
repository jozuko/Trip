import 'package:equatable/equatable.dart';

///
/// Created by jozuko on 2023/03/10.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
abstract class SharedData extends Equatable {
  final String url;
  final String title;
  final String description;
  final String imageUrl;

  const SharedData({
    required this.url,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  SharedData copyWith({
    String? url,
    String? title,
    String? description,
    String? imageUrl,
  });
}
